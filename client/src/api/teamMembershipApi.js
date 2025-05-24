import axios from 'axios';

const API_URL = 'http://localhost:5000/team_memberships';

export const requestToJoinTeam = async (team_id, user_id) => {
    return axios.post(`${API_URL}/request`, { team_id, user_id });
};

export const getUserActiveTeams = async (user_id) => {
    const res = await axios.get(`${API_URL}/user/${user_id}`);
    return res.data; // array of team_ids
};

export const getPendingRequestsForAdmin = async (admin_id) => {
    const res = await axios.get(`${API_URL}/pending/${admin_id}`);
    return res.data; // array of {id, team_id, user_id, role}
};

export const approveRequest = async (membership_id) => {
    return axios.put(`${API_URL}/approve/${membership_id}`);
};

export const rejectRequest = async (membership_id) => {
    return axios.delete(`${API_URL}/reject/${membership_id}`);
};
