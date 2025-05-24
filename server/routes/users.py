from flask import Blueprint, request, jsonify
from models import db, User, Organization

users_bp = Blueprint('users', __name__)

@users_bp.route('', methods=['POST'])
def create_user():
    print("Creating user/n/n----------------------------------------------")
    data = request.get_json()
    print(data)
    user = User(
        id = data.get('id'),
        firstname = data.get('firstName'),
        lastname = data.get('lastName'),
        email = data.get('email'),
        role = data.get('role'),
    )
    # get the organization name from the metadata
    organization_name = data.get('orgName')
    organization = Organization.query.filter_by(name=organization_name).first()
    if not organization:
        organization = Organization(name=organization_name)
        db.session.add(organization)
        db.session.commit()
        user.organization_id = organization.id
    else:
        user.organization_id = organization.id

    db.session.add(user)
    db.session.commit()
    return jsonify({'message': 'User created successfully', 'organization_id': organization.id}), 201

@users_bp.route('/', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify([user.to_dict() for user in users]), 200

@users_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({'message': 'User not found'}), 404
    return jsonify(user.to_dict()), 200

@users_bp.route('/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.get_json()
    user = User.query.get(user_id)
    if not user:
        return jsonify({'message': 'User not found'}), 404
    user.name = data.get('name')
    user.email = data.get('email')
    user.password = data.get('password')
    user.role = data.get('role')
    db.session.commit()
    return jsonify({'message': 'User updated successfully'}), 200

@users_bp.route('/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({'message': 'User not found'}), 404
    db.session.delete(user)
    db.session.commit()
    return jsonify({'message': 'User deleted successfully'}), 200


