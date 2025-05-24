import axios from 'axios';

const API_URL = `${import.meta.env.VITE_DEPLOYED_BASE_URL}/incidents`;

export const createIncident = async (incidentData) => {
    const response = await axios.post(API_URL, incidentData);
    return response.data;
};

export const getIncidents = async () => {
    const response = await axios.get(API_URL);
    return response.data;
};

export const updateIncident = async (id, incidentData) => {
    const response = await axios.put(`${API_URL}/${id}`, incidentData);
    return response.data;
};

export const getIncidentsByOrganization = async (organizationId) => {
    const response = await axios.get(`${API_URL}/organization/${organizationId}`);
    return response.data;
};

