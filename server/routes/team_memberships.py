from models import db, TeamMembership, Team, User
from flask import Blueprint, request, jsonify

team_memberships_bp = Blueprint('team_memberships', __name__)

@team_memberships_bp.route('/request', methods=['POST'])
def request_to_join_team():
    data = request.get_json()
    team_id = data['team_id']
    user_id = data['user_id']
    # Check if already exists
    existing = TeamMembership.query.filter_by(team_id=team_id, user_id=user_id).first()
    if existing:
        return jsonify({'message': 'Already requested or member'}), 400
    membership = TeamMembership(team_id=team_id, user_id=user_id, role='member', membership_status=False)
    db.session.add(membership)
    db.session.commit()
    return jsonify({'message': 'Request sent'}), 201

@team_memberships_bp.route('/pending/<admin_id>', methods=['GET'])
def get_pending_requests(admin_id):
    admin = User.query.filter_by(id=admin_id).first()
    organization_id = admin.organization_id
    teams = Team.query.filter_by(organization_id=organization_id).all() 
    team_ids = [t.id for t in teams]
    pending = TeamMembership.query.filter(TeamMembership.team_id.in_(team_ids), TeamMembership.membership_status==False).all()
    pending_teams = []
    for p in pending:
        team = Team.query.filter_by(id=p.team_id).first()
        user = User.query.filter_by(id=p.user_id).first()
        pending_teams.append({
            'id': p.id,
            'team_id': p.team_id,
            'team_name': team.name,
            'user_id': p.user_id,
            'user_name': user.firstname + ' ' + user.lastname
        })
    return jsonify(pending_teams), 200
    
@team_memberships_bp.route('/approve/<membership_id>', methods=['PUT'])
def approve_request(membership_id):
    membership = TeamMembership.query.get(membership_id)
    if not membership:
        return jsonify({'message': 'Not found'}), 404
    membership.membership_status = True
    db.session.commit()
    return jsonify({'message': 'Approved'})

@team_memberships_bp.route('/reject/<membership_id>', methods=['DELETE'])
def reject_request(membership_id):
    membership = TeamMembership.query.get(membership_id)
    if not membership:
        return jsonify({'message': 'Not found'}), 404
    db.session.delete(membership)
    db.session.commit()
    return jsonify({'message': 'Rejected'})

@team_memberships_bp.route('/user/<user_id>', methods=['GET'])
def get_user_teams(user_id):
    memberships = TeamMembership.query.filter_by(user_id=user_id, membership_status=True).all()
    return jsonify([m.team_id for m in memberships])


