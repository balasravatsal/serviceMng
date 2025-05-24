import { useEffect, useState } from 'react';
import { Box, Typography, Chip, List, ListItem, Card, CardActionArea, FormControl, InputLabel, Select, MenuItem, TextField, InputAdornment, Button } from '@mui/material';
import Timeline from '@mui/lab/Timeline';
import TimelineItem from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';
import axios from 'axios';
import TimelineModal from '../components/modal/TimelineModal';
import { getOrganizations } from '../api/organizationApi';
import { getServices, getServicesByOrganizationId } from '../api/servicesApi';
import SearchIcon from '@mui/icons-material/Search';
import { useUser } from '@clerk/clerk-react';

export default function PublicStatusPage() {
    const [organizations, setOrganizations] = useState([]);
    const [selectedOrg, setSelectedOrg] = useState('');
    const [services, setServices] = useState([]);
    const [filteredServices, setFilteredServices] = useState([]);
    const [selectedService, setSelectedService] = useState(null);
    const [timeline, setTimeline] = useState([]);
    const [loadingTimeline, setLoadingTimeline] = useState(false);
    const [timelineModalOpen, setTimelineModalOpen] = useState(false);
    const [search, setSearch] = useState('');
    const [statusFilter, setStatusFilter] = useState('');
    const [subscriptions, setSubscriptions] = useState(new Set());

    const { user } = useUser();

    useEffect(() => {
        (async () => {
            const orgRes = await getOrganizations();
            setOrganizations(orgRes.data);
            if (user && (user.organizationId || user.organization?.id || user.unsafeMetadata?.organizationId)) {
                const orgId = user.organizationId || user.organization?.id || user.unsafeMetadata?.organizationId;
                setSelectedOrg(orgId);
                const res = await axios.get(`${import.meta.env.VITE_DEPLOYED_BASE_URL}/services/getsubservices`, {
                    params: { user_id: user.id, organization_id: orgId }
                });
                setServices(res.data.services || []);
                setSubscriptions(new Set(res.data.services.filter(service => service.subscribed).map(service => service.id)));
                setFilteredServices(res.data.services.filter(service => service.organization_id === orgId) || []); // Filter services by organization
            } else {
                const res = await getServices()
                setServices(res.services)
                setFilteredServices(res.services)
            }
        })();
    }, [user]);

    const fetchAllServices = async () => {
        try {
            const res = await axios.get(`${import.meta.env.VITE_DEPLOYED_BASE_URL}/services/`);
            setFilteredServices(res.data.services)
        } catch (error) {
            console.error('Error fetching services:', error);
            setFilteredServices([]);
        }
    };

    const fetchServices = async (orgId) => {
        try {
            const res = await axios.get(`${import.meta.env.VITE_DEPLOYED_BASE_URL}/services/getsubservices`, {
                params: { user_id: user.id, organization_id: orgId }
            });
            setServices(res.data.services || []);
            setSubscriptions(new Set(res.data.services.filter(service => service.subscribed).map(service => service.id)));
            setFilteredServices(res.data.services || []); // Initially show all services
        } catch (error) {
            console.error('Error fetching services by organization:', error);
            setServices([]); // Ensure services is always an array
        }
    };

    const handleOrgChange = (e) => {
        const orgId = e.target.value;
        console.log(orgId)
        setSelectedOrg(orgId);
        if (orgId !== '*') {
            console.log(services)
            // Filter services by selected organization
            const filtered = services.filter(service => service.organization_id === orgId);
            console.log(filtered)
            setFilteredServices(filtered);
        } else {
            // Show all services if no organization is selected
            setFilteredServices(services);
        }
    };

    const fetchTimeline = async (serviceId) => {
        setLoadingTimeline(true);
        setTimeline([]);
        try {
            const res = await axios.get(`${import.meta.env.VITE_DEPLOYED_BASE_URL}/services/${serviceId}/timeline`);
            setTimeline(res.data);
        } finally {
            setLoadingTimeline(false);
        }
    };

    // Helper for status chip color
    const getStatusColor = (status) => {
        switch (status) {
            case 'Operational': return 'success';
            case 'Degraded Performance': return 'warning';
            case 'Partial Outage': return 'info';
            case 'Major Outage': return 'error';
            case 'Open': return 'warning';
            case 'In Progress': return 'info';
            case 'Resolved': return 'success';
            default: return 'default';
        }
    };

    const handleServiceClick = (service) => {
        setSelectedService(service);
        fetchTimeline(service.id);
        setTimelineModalOpen(true);
    };

    // Partition timeline by incident_id
    const partitionedTimelines = {};
    timeline.forEach(update => {
        if (!partitionedTimelines[update.incident_id]) {
            partitionedTimelines[update.incident_id] = [];
        }
        partitionedTimelines[update.incident_id].push(update);
    });
    Object.values(partitionedTimelines).forEach(updates => {
        updates.sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
    });

    // Map orgId to orgName for display
    const orgIdToName = organizations.reduce((acc, org) => {
        acc[org.id] = org.name;
        return acc;
    }, {});

    // Filtered services by search and status
    const displayedServices = filteredServices.filter(service =>
        (search === '' || service.name.toLowerCase().includes(search.toLowerCase()) || service.description?.toLowerCase().includes(search.toLowerCase())) &&
        (statusFilter === '' || service.current_status === statusFilter)
    );

    // Modify handleSubscribe to toggle subscription
    const handleSubscribeToggle = async (serviceId) => {
        if (!user) {
            // Redirect to landing page if not logged in
            window.location.href = '/landing';
            return;
        }
        try {
            if (subscriptions.has(serviceId)) {
                // Unsubscribe logic
                await axios.post(`${import.meta.env.VITE_DEPLOYED_BASE_URL}/subscriptions/unsubscribe`, {
                    user_id: user.id,
                    service_id: serviceId
                });
                setSubscriptions(prev => {
                    const newSet = new Set(prev);
                    newSet.delete(serviceId);
                    return newSet;
                });
            } else {
                // Subscribe logic
                await axios.post(`${import.meta.env.VITE_DEPLOYED_BASE_URL}/subscriptions/subscribe`, {
                    user_id: user.id,
                    service_id: serviceId
                });
                setSubscriptions(prev => new Set(prev).add(serviceId));
            }
        } catch (error) {
            console.error('Error toggling subscription:', error);
        }
    };

    return (
        <Box sx={{ p: { xs: 1, md: 3 }, maxWidth: 900, mx: 'auto' }}>
            <Typography variant="h3" color="primary" sx={{ fontWeight: 700, mb: 3, textAlign: 'center' }}>Services Status</Typography>
            <Box sx={{ display: 'flex', gap: 2, mb: 3, flexWrap: 'wrap', alignItems: 'center' }}>
                <FormControl size="small" sx={{ minWidth: 200, bgcolor: '#fff', borderRadius: 2 }}>
                    <InputLabel>Organization</InputLabel>
                    <Select
                        value={selectedOrg}
                        label="Organization"
                        onChange={handleOrgChange}
                        displayEmpty
                        disabled={false}
                    >
                        <MenuItem key="all" value="*">All Organizations</MenuItem>
                        {organizations.map(org => (
                            <MenuItem key={org.id} value={org.id}>{org.name}</MenuItem>
                        ))}
                    </Select>
                </FormControl>
                <TextField
                    label="Search Services"
                    value={search}
                    onChange={e => setSearch(e.target.value)}
                    size="small"
                    sx={{ minWidth: 200, bgcolor: '#fff', borderRadius: 2 }}
                    InputProps={{
                        startAdornment: (
                            <InputAdornment position="start">
                                <SearchIcon />
                            </InputAdornment>
                        ),
                    }}
                />
                <FormControl size="small" sx={{ minWidth: 180, bgcolor: '#fff', borderRadius: 2 }}>
                    <InputLabel>Status</InputLabel>
                    <Select
                        value={statusFilter}
                        label="Status"
                        onChange={e => setStatusFilter(e.target.value)}
                    >
                        <MenuItem value="">All</MenuItem>
                        <MenuItem value="Operational">Operational</MenuItem>
                        <MenuItem value="Degraded Performance">Degraded Performance</MenuItem>
                        <MenuItem value="Partial Outage">Partial Outage</MenuItem>
                        <MenuItem value="Major Outage">Major Outage</MenuItem>
                    </Select>
                </FormControl>
            </Box>
            <Typography variant="h5" color="primary" sx={{ fontWeight: 600, mb: 2 }}>Services</Typography>
            <List>
                <ListItem sx={{ fontWeight: 'bold', bgcolor: '#030027', color: '#fff', display: { xs: 'none', md: 'flex' }, alignItems: 'center' }}>
                    <Box sx={{ flex: 2 }}>Name</Box>
                    <Box sx={{ flex: 3 }}>Description</Box>
                    <Box sx={{ flex: 2 }}>Status</Box>
                    {(!user || !selectedOrg) && <Box sx={{ flex: 2 }}>Organization</Box>}
                </ListItem>
                {displayedServices.map(service => (
                    <Card key={service.id} sx={{ mb: 2, bgcolor: selectedService?.id === service.id ? '#e3f2fd' : '#fff' }}>
                        <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', p: 1 }} onClick={() => handleServiceClick(service)}>
                            <Box sx={{ flex: 1, display: 'flex', alignItems: 'center' }}>
                                <Box sx={{ flex: 2, fontWeight: 600 }}>{service.name}</Box>
                                <Box sx={{ flex: 3 }}>{service.description}</Box>
                                <Box sx={{ flex: 2 }}><Chip label={service.current_status} color={getStatusColor(service.current_status)} /></Box>
                                {/* Show org name if no user or all orgs selected */}
                                {(!user || !selectedOrg) && (
                                    <Box sx={{ flex: 2, color: 'text.secondary', fontStyle: 'italic' }}>{service.organization_name || ''}</Box>
                                )}
                            </Box>
                            <Button variant="contained" color="primary" onClick={(e) => { e.stopPropagation(); handleSubscribeToggle(service.id); }}>
                                {subscriptions.has(service.id) ? 'Unsubscribe' : 'Subscribe'}
                            </Button>
                        </Box>
                    </Card>
                ))}
            </List>
            <TimelineModal
                open={timelineModalOpen}
                onClose={() => setTimelineModalOpen(false)}
                service={selectedService}
                partitionedTimelines={partitionedTimelines}
                getStatusColor={getStatusColor}
                loading={loadingTimeline}
            />
        </Box>
    );
}
