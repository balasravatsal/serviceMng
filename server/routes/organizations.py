from flask import Blueprint, request, jsonify
from models import db, Organization

organizations_bp = Blueprint('organizations', __name__)

# Create a new organization
@organizations_bp.route('/', methods=['POST'])
def create_organization():
    print("Creating organization")
    data = request.get_json()
    organization = Organization(
        name=data.get('name')
    )
    db.session.add(organization)
    db.session.commit()
    return jsonify({'message': 'Organization created successfully'}), 201


# Get all organizations
@organizations_bp.route('/', methods=['GET'])
def get_organizations():
    organizations = Organization.query.all()
    return jsonify([organization.to_dict() for organization in organizations]), 200


# Get a single organization by ID
@organizations_bp.route('/<int:org_id>', methods=['GET'])
def get_organization(org_id):
    organization = Organization.query.get(org_id)
    if not organization:
        return jsonify({'message': 'Organization not found'}), 404
    return jsonify(organization.to_dict()), 200


# Update an organization
@organizations_bp.route('/<int:org_id>', methods=['PUT'])
def update_organization(org_id):
    data = request.get_json()
    organization = Organization.query.get(org_id)
    if not organization:
        return jsonify({'message': 'Organization not found'}), 404
    organization.name = data.get('name')
    db.session.commit()
    return jsonify({'message': 'Organization updated successfully'}), 200


# Delete an organization
@organizations_bp.route('/<int:org_id>', methods=['DELETE'])
def delete_organization(org_id):
    organization = Organization.query.get(org_id)
    if not organization:
        return jsonify({'message': 'Organization not found'}), 404
    db.session.delete(organization)
    db.session.commit()
    return jsonify({'message': 'Organization deleted successfully'}), 200


