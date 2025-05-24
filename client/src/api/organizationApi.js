import axios from 'axios';

const API_URL = 'http://localhost:5000/organizations';

export const createOrganization = async (organizationData) => {
    return axios.post(API_URL, organizationData);
};

export const getOrganizations = async () => {
    return axios.get(API_URL);
};

export const getOrganization = async (orgId) => {
    return axios.get(`${API_URL}/${orgId}`);
};

export const updateOrganization = async (orgId, organizationData) => {
    return axios.put(`${API_URL}/${orgId}`, organizationData);
};

export const deleteOrganization = async (orgId) => {
    return axios.delete(`${API_URL}/${orgId}`);
};
