from flask import Flask, jsonify, request
from flask_mysqldb import MySQL
from users import create_transaction, get_transactions, update_transaction, delete_transaction, get_transaction
from database import set_mysql

app = Flask(__name__)

#Required
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_PORT"] = 3306
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = "GNMebeb(03)" #ilisi saimong password
app.config["MYSQL_DB"] = "tracker"
#Extra configs, optional but mandatory for this project:
app.config["MYSQL_CURSORCLASS"] = "DictCursor"
app.config["MYSQL_AUTOCOMMIT"] = True

mysql = MySQL(app)
set_mysql(mysql)

@app.route("/")
def home():
  return jsonify({"message": "Hello, EBEB!"})


@app.route("/transactions", methods=["GET", "POST"])
def transactions():
    if request.method == "POST":
        data = request.get_json()
        trans_id = create_transaction(
            data["user_id"], data["cat_id"], 
            data["amount"], data["description"], data["trans_date"]
        )
        return jsonify({"trans_id": trans_id})
    else:
        transactions = get_transactions()
        return jsonify(transactions)

@app.route("/transactions/<int:trans_id>", methods=["GET", "PUT", "DELETE"])
def transaction(trans_id):
    if request.method == "PUT":
        data = request.get_json()
        trans_id = update_transaction(
            trans_id,
            data["user_id"], data["cat_id"], 
            data["amount"], data["description"], data["trans_date"]
        )
        return jsonify({"trans_id": trans_id})
    elif request.method == "DELETE":
        trans_id = delete_transaction(trans_id)
        return jsonify({"trans_id": trans_id})
    else:
        transaction = get_transaction(trans_id)
        return jsonify(transaction)