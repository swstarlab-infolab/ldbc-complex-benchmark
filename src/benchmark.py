#!/usr/bin/env python3

import os
import sys
import psycopg
import time

class PostgresDbLoader():

    def __init__(self, queries):
        self.database = os.environ.get("POSTGRES_DB", "ldbcsnb")
        self.endpoint = os.environ.get("POSTGRES_HOST", "localhost")
        self.port = int(os.environ.get("POSTGRES_PORT", 5435))
        self.user = os.environ.get("POSTGRES_USER", "postgres")
        self.password = os.environ.get("POSTGRES_PASSWORD", "mysecretpassword")
        self.queries = queries

    def main(self):
        
        total_times = []
        with psycopg.connect(
            dbname=self.database,
            host=self.endpoint,
            user=self.user,
            password=self.password,
            port=self.port
        ) as conn:
            # disable auto_commit
            conn.autocommit = False
            with conn.cursor() as cur:
                # configure system parameters
                cur.execute("LOAD 'pg_graph'")
                conn.commit()
                cur.execute("SET SEARCH_PATH=graph_catalog, '$user', public;")
                conn.commit() 
                cur.execute("SET enable_indexonlyscan = off;")
                conn.commit() 
                cur.execute("SET enable_graphplan = on;")
                conn.commit() 
                cur.execute("SET enable_tableplan = off;")
                conn.commit() 

                # iterate input queries and execute them
                for query in self.queries:
                    print(f"Executing query: {query}")
                    times = []
                    for _ in range(50):
                        # measure execution time
                        start = time.time()
                        cur.execute(self.load_script(f"queries/{query}.sql"))
                        execution_time = time.time() - start
                        times.append(execution_time)
                        total_times.append(execution_time)
                        conn.rollback()

                    print(f"Average execution time: {sum(times) / len(times)}")

            # conn.commit()
        print(f"Total average execution time: {sum(total_times) / len(total_times)}")

    def load_script(self, filename):
        with open(filename, "r") as f:
            return f.read()


if __name__ == "__main__":
    # get multiple command line inputs
    queries = []
    for i in range(1, len(sys.argv)):
        queries.append(sys.argv[i])

    PGLoader = PostgresDbLoader(queries)

    # wait until input 'y'
    while True:
        if input("Start benchmarking? (y/n): ") == "y":
            PGLoader.main()
            break
 