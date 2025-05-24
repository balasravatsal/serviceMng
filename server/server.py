from flask import Flask
from models import db
from flask_cors import CORS
import config

from routes.users import users_bp
from routes.organizations import organizations_bp
from routes.teams import teams_bp
from routes.services import services_bp
from routes.incidents import incidents_bp
from routes.team_memberships import team_memberships_bp
from routes.subscriptions import subscriptions_bp
from routes.notifications import notifications_bp

app = Flask(__name__)
app.config.from_object(config)
db.init_app(app)


CORS(app,
     resources={r"/*": {"origins": ["http://localhost:5173", "http://127.0.0.1:5173", "*"]}},
     supports_credentials=True,
     methods=["GET", "POST", "PUT", "DELETE", "OPTIONS"],
     allow_headers=["Content-Type", "Authorization"])

app.register_blueprint(users_bp, url_prefix='/users')
app.register_blueprint(organizations_bp, url_prefix='/organizations')
app.register_blueprint(teams_bp, url_prefix='/teams')
app.register_blueprint(services_bp, url_prefix='/services')
app.register_blueprint(incidents_bp, url_prefix='/incidents')
app.register_blueprint(team_memberships_bp, url_prefix='/team_memberships')
app.register_blueprint(subscriptions_bp, url_prefix='/subscriptions')
app.register_blueprint(notifications_bp, url_prefix='/notifications')


@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

if __name__ == "__main__":
    app.run(debug=True)