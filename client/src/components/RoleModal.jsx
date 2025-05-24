import React, { useState, useEffect } from 'react';
import { getOrganizations } from '../api/organizationApi';
import { Box, Button, FormControl, FormLabel, RadioGroup, FormControlLabel, Radio, TextField, Select, MenuItem } from '@mui/material';

export default function RoleModal({ onSubmit }) {
    const [role, setRole] = useState('');
    const [orgName, setOrgName] = useState('');
    const [organizations, setOrganizations] = useState([]);

    useEffect(() => {
        (async () => {
            const res = await getOrganizations();
            setOrganizations(res.data);
        })();
    }, []);

    const handleSubmit = (e) => {
        e.preventDefault();
        const userDetails = {
            role,
            orgName: role === 'admin' ? orgName : role === 'member' ? orgName : undefined,
        };
        console.log('User details:', userDetails);
        if (onSubmit) onSubmit(userDetails);
    };

    return (
        <Box
            component="form"
            onSubmit={handleSubmit}
            sx={{
                position: 'fixed',
                top: 0, left: 0, width: '100vw', height: '100vh',
                bgcolor: 'rgba(0,0,0,0.5)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                p: 3,
                zIndex: 1300,
            }}
        >
            <Box
                sx={{
                    bgcolor: '#bcedf6',
                    p: 4,
                    borderRadius: 0,
                    minWidth: 300,
                    display: 'flex',
                    flexDirection: 'column',
                    gap: 2,
                    boxShadow: 4,
                    maxWidth: '90vw',
                }}
            >
                <FormControl>
                    <FormLabel>Are you joining as an Admin or Member?</FormLabel>
                    <RadioGroup
                        row
                        value={role}
                        onChange={(e) => {
                            setRole(e.target.value);
                            setOrgName('');
                        }}
                    >
                        <FormControlLabel value="admin" control={<Radio />} label="Admin" />
                        <FormControlLabel value="member" control={<Radio />} label="Member" />
                    </RadioGroup>
                </FormControl>

                {role === 'admin' && (
                    <TextField
                        label="Organization Name"
                        value={orgName}
                        onChange={(e) => setOrgName(e.target.value)}
                        required
                        fullWidth
                        sx={{ bgcolor: '#fff', borderRadius: 2 }}
                    />
                )}

                {role === 'member' && (
                    <FormControl fullWidth required sx={{ bgcolor: '#fff', borderRadius: 2 }}>
                        <Select
                            value={orgName}
                            displayEmpty
                            onChange={(e) => setOrgName(e.target.value)}
                            renderValue={(selected) => selected || "Select Organization"}
                        >
                            <MenuItem disabled value="">
                                Select Organization
                            </MenuItem>
                            {organizations.map((org) => (
                                <MenuItem key={org.id} value={org.name}>
                                    {org.name}
                                </MenuItem>
                            ))}
                        </Select>
                    </FormControl>
                )}

                <Button type="submit" variant="contained" disabled={!role || !orgName} sx={{ borderRadius: 0.625, bgcolor: 'primary.main', color: '#fff' }}>
                    Continue
                </Button>
            </Box>
        </Box>
    );
}
