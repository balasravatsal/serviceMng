from flask import Blueprint, request, jsonify
from models import db, Subscription

subscriptions_bp = Blueprint('subscriptions', __name__)

@subscriptions_bp.route('/subscribe', methods=['POST'])
def subscribe():
    data = request.json
    user_id = data.get('user_id')
    service_id = data.get('service_id')

    if not user_id or not service_id:
        return jsonify({'error': 'User ID and Service ID are required'}), 400

    subscription = Subscription(user_id=user_id, service_id=service_id)
    db.session.add(subscription)
    db.session.commit()

    return jsonify({'message': 'Subscribed successfully'}), 201

@subscriptions_bp.route('/unsubscribe', methods=['POST'])
def unsubscribe():
    data = request.json
    user_id = data.get('user_id')
    service_id = data.get('service_id')

    if not user_id or not service_id:
        return jsonify({'error': 'User ID and Service ID are required'}), 400

    subscription = Subscription.query.filter_by(user_id=user_id, service_id=service_id).first()
    if subscription:
        db.session.delete(subscription)
        db.session.commit()
        return jsonify({'message': 'Unsubscribed successfully'}), 200
    else:
        return jsonify({'error': 'Subscription not found'}), 404 