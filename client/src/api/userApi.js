import axios from 'axios';

const API_URL = `${import.meta.env.VITE_DEPLOYED_BASE_URL}/users`;

export const createUser = async (userData) => {
  console.log(userData);

  const response = await axios.post(API_URL, userData);
  console.log(response);
  return response;
};

export const getUsers = async () => {
  return axios.get(API_URL);
};

export const getUser = async (userId) => {
  return axios.get(`${API_URL}/${userId}`);
};

export const updateUser = async (userId, userData) => {
  return axios.put(`${API_URL}/${userId}`, userData);
};

export const deleteUser = async (userId) => {
  return axios.delete(`${API_URL}/${userId}`);
};
