#!/usr/bin/python3

import cgi
import MySQLdb
import random
import passwords

form = cgi.FieldStorage()

if "user" in form:
	user = form["user"].value
else:
    print("Status: 400 Bad Request")
    print("Content-Type: text/html")
    print()
    
    print("<html><body>400 Bad Request</body></html>")
    exit()

ID_as_int = random.randint(0, 16**64)
ID_as_str = "%064x" % ID_as_int

conn = MySQLdb.connect(
      host = passwords.host,
      user = passwords.user,
      passwd = passwords.passwd,
      db = "servers"
      )
cur = conn.cursor()
cur.execute("INSERT INTO sessions (id, user) VALUES (%s, %s);", (ID_as_str, user))
conn.commit()
cur.close()
conn.close()

print("Status: 303 Redirect")
print(f"Set-Cookie: session_id={ID_as_str}")
print("Location: /cgi-bin/main")
print()