#!/usr/bin/env python3

import os
import psycopg

class PostgresDbLoader():

    def __init__(self):
        self.database = os.environ.get("PG_GRAPH_DB", "ldbcsnb")
        self.endpoint = os.environ.get("PG_GRAPH_HOST", "localhost")
        self.port = int(os.environ.get("PG_GRAPH_PORT", 5432))
        self.user = os.environ.get("PG_GRAPH_USER", "postgres")
        self.password = os.environ.get("PG_GRAPH_PASSWORD", "mysecretpassword")

    def analyze(self, conn):
        conn.autocommit=True
        conn.cursor().execute("ANALYZE")
        conn.autocommit=False

    def vacuum(self, conn):
        conn.autocommit=True
        conn.cursor().execute("VACUUM FULL")
        conn.autocommit=False
    
    def checkpoint(self, conn):
        conn.autocommit=True
        conn.cursor().execute("CHECKPOINT")
        conn.autocommit=False

    def main(self):
        with psycopg.connect(
            dbname=self.database,
            host=self.endpoint,
            user=self.user,
            password=self.password,
            port=self.port
        ) as conn:
            with conn.cursor() as cur:
                print("Loading initial data set")
                cur.execute(self.load_script(f"ddl/schema.sql"))
                cur.execute(self.load_script(f"ddl/load.sql"))
                conn.commit()

                print("Adding indexes and constraints")
                cur.execute(self.load_script(f"ddl/schema_constraints.sql"))
                conn.commit()

                print("Alter schema")
                cur.execute(self.load_script(f"ddl/alter.sql"))
                conn.commit()

                print("Create graph")
                cur.execute(self.load_script(f"ddl/create_graph.sql"))
                conn.commit()

                print("Clear property")
                cur.execute(self.load_script(f"ddl/clear_prop.sql"))
                conn.commit()

                print("Checkpointing")
                self.checkpoint(conn)

                print("Vacuuming")
                # self.vacuum(conn)
                self.analyze(conn)
                
                # print("Checkpointing")
                # self.checkpoint(conn)
                
            conn.commit()
        print("Loaded initial snapshot")

    def load_script(self, filename):
        with open(filename, "r") as f:
            return f.read()


if __name__ == "__main__":
    PGLoader = PostgresDbLoader()
    PGLoader.main()
