from flask import Blueprint, request, jsonify
from models import db, Team, User, TeamMembership

teams_bp = Blueprint('teams', __name__)

@teams_bp.route('', methods=['POST'])
def create_team():
    data = request.get_json()
    team = Team(
        name=data.get('name'),
        organization_id=data.get('organization_id')
    )
    db.session.add(team)
    db.session.commit()
    # get the team id and store user id and team id in the membership table
    team_id = team.id
    user_id = data.get('user_id')
    role = data.get('role')
    membership = TeamMembership(
        team_id=team_id,
        user_id=user_id,
        role=role,
        membership_status=True
    )
    db.session.add(membership)
    db.session.commit() 
    return jsonify({'message': 'Team created successfully'}), 201

@teams_bp.route('/', methods=['GET'])
def get_teams():
    teams = Team.query.all()    
    return jsonify([team.to_dict() for team in teams]), 200

@teams_bp.route('/<int:team_id>', methods=['GET'])
def get_team(team_id):
    team = Team.query.get(team_id)
    if not team:
        return jsonify({'message': 'Team not found'}), 404
    return jsonify(team.to_dict()), 200

@teams_bp.route('/<int:team_id>', methods=['PUT'])
def update_team(team_id):
    data = request.get_json()
    team = Team.query.get(team_id)
    if not team:
        return jsonify({'message': 'Team not found'}), 404
    team.name = data.get('name')
    db.session.commit()
    return jsonify({'message': 'Team updated successfully'}), 200

@teams_bp.route('/<int:team_id>', methods=['DELETE'])
def delete_team(team_id):
    team = Team.query.get(team_id)
    if not team:
        return jsonify({'message': 'Team not found'}), 404
    db.session.delete(team)
    db.session.commit()
    return jsonify({'message': 'Team deleted successfully'}), 200


@teams_bp.route('/user/<string:user_id>', methods=['GET'])
def get_teams_by_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if not user:
        return jsonify({'message': 'User nhhhhot found'}), 404
    organization_id = user.organization_id
    teams = Team.query.filter_by(organization_id=organization_id).all()
    team_list = [team.to_dict() for team in teams]
    return jsonify(team_list), 200


