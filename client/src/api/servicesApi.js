import axios from 'axios';

const API_URL = 'http://localhost:5000/services';

export const getServices = async () => {
    const response = await axios.get(API_URL);
    return response.data;
};

export const getServicesByOrganizationId = async (organizationId) => {
    const response = await axios.get(`${API_URL}/organization/${organizationId}`);
    return response.data;
};

export const getServicesByUserId = async (userId) => {
    const response = await axios.get(`${API_URL}/user/${userId}`);
    return response.data;
};

export const createService = async (serviceData) => {
    const response = await axios.post(API_URL, serviceData);
    return response.data;
};

export const updateService = async (serviceId, serviceData) => {
    const response = await axios.put(`${API_URL}/${serviceId}`, serviceData);
    return response.data;
};

export const deleteService = async (serviceId) => {
    const response = await axios.delete(`${API_URL}/${serviceId}`);
    return response.data;
};

export const getServiceById = async (serviceId) => {
    const response = await axios.get(`${API_URL}/${serviceId}`);
    return response.data;
};

export const getServicesByTeamId = async (teamId) => {
    const response = await axios.get(`${API_URL}/team/${teamId}`);
    return response.data;
};




















