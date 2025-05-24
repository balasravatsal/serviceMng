from flask import Blueprint, request, jsonify
from models import db, Service, Team, TeamMembership, User, IncidentServiceLink, IncidentUpdate, Incident, Organization, Subscription

services_bp = Blueprint('services', __name__)

@services_bp.route('/', methods=['POST'])
def create_service():
    data = request.get_json()
    created_by_user_id = data.get('created_by_user_id')
    user = User.query.filter_by(id=created_by_user_id).first()
    if not user:
        return jsonify({'error': 'User not found'}), 400
    organization_id = user.organization_id
    # print(organization_id,  "||||||||||||||||||||||||||||||||||||||||||||||||||||")

    service = Service(
        name=data.get('name'),
        description=data.get('description'),
        current_status=data.get('current_status'),
        team_id=data.get('team_id'),
        organization_id=organization_id
    )
    db.session.add(service)
    db.session.commit()
    return jsonify({'message': 'Service created successfully'}), 201

@services_bp.route('', methods=['GET'])
def get_services():
    services = Service.query.all()
    service_list = []
    
    # Fetch subscriptions for the current user
    user_id = request.args.get('user_id')
    subscriptions = Subscription.query.filter_by(user_id=user_id).all()
    subscribed_service_ids = {sub.service_id for sub in subscriptions}

    for service in services:
        service_dict = service.to_dict()
        team = Team.query.filter_by(id=service.team_id).first()
        organization = Organization.query.filter_by(id=team.organization_id).first()
        service_dict['organization_name'] = organization.name
        service_dict['organization_id'] = organization.id
        # Add subscription status
        service_dict['subscribed'] = service.id in subscribed_service_ids
        service_list.append(service_dict)

    return jsonify({'services': service_list}), 200
    
@services_bp.route('/<int:service_id>', methods=['GET'])
def get_service(service_id):
    service = Service.query.get(service_id)
    if not service:
        return jsonify({'message': 'Service not found'}), 404
    return jsonify(service.to_dict()), 200

@services_bp.route('/<int:service_id>', methods=['PUT'])
def update_service(service_id):
    data = request.get_json()
    service = Service.query.get(service_id)
    if not service:
        return jsonify({'message': 'Service not found'}), 404
    service.name = data.get('name')
    service.description = data.get('description')
    service.current_status = data.get('current_status')
    service.team_id = data.get('team_id')
    db.session.commit()

    return jsonify({'message': 'Service updated and subscribers notified'}), 200

@services_bp.route('/<int:service_id>', methods=['DELETE'])
def delete_service(service_id):
    service = Service.query.get(service_id)
    if not service:
        return jsonify({'message': 'Service not found'}), 404
    db.session.delete(service)
    db.session.commit()
    return jsonify({'message': 'Service deleted successfully'}), 200


# get services by team id
@services_bp.route('/team/<int:team_id>', methods=['GET'])
def get_services_by_team_id(team_id):
    services = Service.query.filter_by(team_id=team_id).all()
    return jsonify([service.to_dict() for service in services]), 200

# get services by user id
@services_bp.route('/user/<string:user_id>', methods=['GET'])
def get_services_by_user_id(user_id):
    print(user_id)
    user = User.query.filter_by(id=user_id).first()
    organization_id = user.organization_id
    teams = Team.query.filter_by(organization_id=organization_id).all()
    team_ids = [team.id for team in teams]
    services = Service.query.filter(Service.team_id.in_(team_ids)).all()
    return jsonify([service.to_dict() for service in services]), 200

# get services by organization id
@services_bp.route('/organization/<int:organization_id>', methods=['GET'])
def get_services_by_organization_id(organization_id):
    try:
        services = (
            db.session.query(Service)
            .join(Team, Service.team_id == Team.id)
            .filter(Team.organization_id == organization_id)
            .all()
        )

        service_list = [
            {
                "id": service.id,
                "name": service.name,
                "team_id": service.team_id,
                "description": service.description,
                "current_status": service.current_status,
            }
            for service in services
        ]

        # Fetch subscriptions for the current user
        user_id = request.args.get('user_id')
        subscriptions = Subscription.query.filter_by(user_id=user_id).all()
        subscribed_service_ids = [sub.service_id for sub in subscriptions]

        return jsonify({'services': service_list, 'subscriptions': subscribed_service_ids}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


# create service
@services_bp.route('', methods=['POST'])
def create_services():
    data = request.get_json()
    service = Service(
        name=data.get('name'),
        description=data.get('description'),
        current_status=data.get('current_status'),
        team_id=data.get('team_id')
    )
    db.session.add(service)
    db.session.commit()
    return jsonify({'message': 'Service created successfully'}), 201

@services_bp.route('/<int:service_id>/timeline', methods=['GET'])
def get_service_timeline(service_id):
    # Find all incidents linked to this service
    links = IncidentServiceLink.query.filter_by(service_id=service_id).all()
    incident_ids = [link.incident_id for link in links]
    # Get all updates for these incidents
    updates = (
        IncidentUpdate.query
        .filter(IncidentUpdate.incident_id.in_(incident_ids))
        .order_by(IncidentUpdate.timestamp.asc())
        .all()
    )
    # Get incident titles for mapping
    incident_map = {inc.id: inc.title for inc in Incident.query.filter(Incident.id.in_(incident_ids)).all()}
    timeline = [
        {
            'id': update.id,
            'incident_id': update.incident_id,
            'incident_title': incident_map.get(update.incident_id, ''),
            'message': update.message,
            'status': update.status,
            'timestamp': update.timestamp.isoformat(),
        }
        for update in updates
    ]
    return jsonify(timeline), 200

@services_bp.route('/getsubservices', methods=['GET'])
def get_subscribed_services():
    user_id = request.args.get('user_id')
    if not user_id:
        return jsonify({'error': 'User ID is required'}), 400

    services = Service.query.all()
    service_list = []
    
    # Fetch subscriptions for the current user
    subscriptions = Subscription.query.filter_by(user_id=user_id).all()
    subscribed_service_ids = {sub.service_id for sub in subscriptions}

    for service in services:
        service_dict = service.to_dict()
        team = Team.query.filter_by(id=service.team_id).first()
        organization = Organization.query.filter_by(id=team.organization_id).first()
        service_dict['organization_name'] = organization.name
        service_dict['organization_id'] = organization.id
        # Add subscription status
        service_dict['subscribed'] = service.id in subscribed_service_ids
        service_list.append(service_dict)

    return jsonify({'services': service_list}), 200














