from flask import Blueprint, request, jsonify
from models import Incident, IncidentServiceLink, db, User, Service, IncidentUpdate, Subscription, Notification
from datetime import datetime

incidents_bp = Blueprint('incidents', __name__)

def notify_subscribers(service_id, message):
    service = Service.query.filter_by(id=service_id).first()
    service_name = service.name
    subscriptions = Subscription.query.filter_by(service_id=service_id).all()
    for subscription in subscriptions:
        notification = Notification(
            message=message,
            user_id=subscription.user_id,
            service_name=service_name
        )
        db.session.add(notification)
    db.session.commit()




@incidents_bp.route('', methods=['POST'])
def create_incident():
    data = request.json
    created_by_user_id = data.get('created_by_user_id')
    user = User.query.filter_by(id=created_by_user_id).first()
    if not user:
        return jsonify({'error': 'User not found'}), 400
    organization_id = user.organization_id
    new_incident = Incident(
        title=data.get('title'),
        description=data.get('description'),
        status=data.get('status'),
        organization_id=organization_id,
        created_by_user_id=created_by_user_id
    )
    db.session.add(new_incident)
    db.session.commit()
    incident_id = new_incident.id
    service_id = data.get('service_id')
    link = IncidentServiceLink(
        incident_id=incident_id,
        service_id=service_id
    )
    db.session.add(link)
    db.session.commit()
    message = data.get('description', '')
    update = IncidentUpdate(
        incident_id=incident_id,
        message=message,
        status=data.get('status')
    )
    db.session.add(update)
    db.session.commit()

    notify_subscribers(service_id, f"New incident: {new_incident.title}")

    return jsonify(new_incident.to_dict()), 201

@incidents_bp.route('/', methods=['GET'])
def get_incidents():
    incidents = Incident.query.all()
    incidents_with_service = []
    for incident in incidents:
        link = IncidentServiceLink.query.filter_by(incident_id=incident.id).first()
        service = Service.query.filter_by(id=link.service_id).first() if link else None
        incident_dict = incident.to_dict()
        incident_dict['service'] = service.to_dict() if service else None
        incidents_with_service.append(incident_dict)
    return jsonify(incidents_with_service)

@incidents_bp.route('/<int:incident_id>', methods=['GET'])
def get_incident(incident_id):
    incident = Incident.query.get(incident_id)
    if not incident:
        return jsonify({'message': 'Incident not found'}), 404
    return jsonify(incident.to_dict())

@incidents_bp.route('/<int:incident_id>', methods=['PUT'])
def update_incident(incident_id):
    data = request.json
    incident = Incident.query.get(incident_id)
    if not incident:
        return jsonify({'message': 'Incident not found'}), 404
    for key, value in data.items():
        setattr(incident, key, value)
    db.session.commit()
    # Add to incident_updates
    message = data.get('description', '')
    status = data.get('status', incident.status)
    update = IncidentUpdate(
        incident_id=incident_id,
        message=message,
        status=status
    )
    db.session.add(update)
    db.session.commit()

    notify_subscribers(incident.service_id, f"Updated incident: {incident.title}")

    return jsonify(incident.to_dict())

@incidents_bp.route('/<int:incident_id>', methods=['DELETE'])
def delete_incident(incident_id):
    incident = Incident.query.get(incident_id)
    if not incident:
        return jsonify({'message': 'Incident not found'}), 404
    # Add to incident_updates before deleting
    message = f"Deleted: {incident.description or ''}"
    status = incident.status
    update = IncidentUpdate(
        incident_id=incident_id,
        message=message,
        status=status
    )
    db.session.add(update)
    db.session.commit()
    db.session.delete(incident)
    db.session.commit()

    notify_subscribers(incident.service_id, f"Deleted incident: {incident.title}")

    return jsonify({'message': 'Incident deleted successfully'}), 200


@incidents_bp.route('/organization/<int:organization_id>/', methods=['GET'])
def get_incidents_by_organization(organization_id):
    incidents = Incident.query.filter_by(organization_id=organization_id).all()
    return jsonify([incident.to_dict() for incident in incidents])











