#!/usr/bin/env python3

import os
import psycopg

conn = psycopg.connect(
        host=os.environ.get("PG_GRAPH_HOST", "localhost"),
        user=os.environ.get("PG_GRAPH_USER", "postgres"),
        password=os.environ.get("PG_GRAPH_PASSWORD", "mysecretpassword"),
        port=int(os.environ.get("PG_GRAPH_PORT", 5432))
    )
conn.close()