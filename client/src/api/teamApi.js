import axios from 'axios';

const API_URL = `${import.meta.env.VITE_DEPLOYED_BASE_URL}/teams`;

export const getTeams = async () => {
    const response = await axios.get(API_URL);
    return response.data;
};


export const getTeamsByUserId = async (userId) => {
    const response = await axios.get(`${API_URL}/user/${userId}`);
    console.log(response.data);
    return response.data;
};

export async function createTeam({ name, organization_id }) {
    const response = await axios.post(API_URL, { name, organization_id });
    return response.data;
}

export const updateTeam = async (teamId, teamData) => {
    const response = await axios.put(`${API_URL}/${teamId}`, teamData);
    return response.data;
};

export const deleteTeam = async (teamId) => {
    const response = await axios.delete(`${API_URL}/${teamId}`);
    return response.data;
};

export const getTeamById = async (teamId) => {
    const response = await axios.get(`${API_URL}/${teamId}`);
    return response.data;
};










