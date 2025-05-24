from flask import Blueprint, jsonify, request
from models import Notification

notifications_bp = Blueprint('notifications', __name__)

@notifications_bp.route('/<string:user_id>', methods=['GET'])
def get_notifications(user_id):
    if not user_id:
        return jsonify({'error': 'User ID is required'}), 400

    notifications = Notification.query.filter_by(user_id=user_id).all()
    print("notifications", notifications)
    notifications_list = [
        {
            'id': notification.id,
            'message': notification.message,
            'service_name': notification.service_name,
            'created_at': notification.timestamp
        }
        for notification in notifications
    ]
    return jsonify({'notifications': notifications_list}) 