import { useEffect, useState } from 'react';
import { MyComponent } from '../components/MyComponent';
import { useUser } from '@clerk/clerk-react';
import RoleModal from '../components/RoleModal';
import { createUser } from '../api/userApi';
import { Box } from '@mui/material';
import { getTeamsByUserId, updateTeam, deleteTeam } from '../api/teamApi';
import { getServicesByUserId, createService, updateService, deleteService } from '../api/servicesApi';
import TeamsPanel from '../components/TeamsPanel';
import ServicesGrid from '../components/ServicesGrid';
import { createTeam } from '../api/teamApi';
import { createIncident } from '../api/incidentApi';

export default function Home() {
    const { isLoaded, isSignedIn, user } = useUser();
    const [showRoleModal, setShowRoleModal] = useState(false);
    const [teams, setTeams] = useState([]);
    const [services, setServices] = useState([]);
    const [selectedTeam, setSelectedTeam] = useState(null);
    const [loadingServices, setLoadingServices] = useState(false);

    useEffect(() => {
        if (isLoaded && isSignedIn && !user.unsafeMetadata?.role) {
            setShowRoleModal(true);
        }
    }, [isLoaded, isSignedIn, user]);

    const handleAddTeam = async (teamName) => {
        const organization_id = teams[0]?.organization_id || user.unsafeMetadata.organizationId;
        const newTeam = await createTeam({ name: teamName, organization_id });
        setTeams(prev => [...prev, { ...newTeam, name: teamName, organization_id }]);
    };

    const fetchTeams = async () => {
        const teams = await getTeamsByUserId(user.id);
        setTeams(teams);
    };
    const fetchServices = async () => {
        setLoadingServices(true);
        const services = await getServicesByUserId(user.id);
        setServices(services);
        setLoadingServices(false);
    };

    useEffect(() => {
        if (!user) return;
        fetchTeams();
        fetchServices();
    }, [user]);

    const handleRoleSubmit = async ({ role, orgName }) => {
        // const metadata = { role, orgName };
        // await user.update({
        //     unsafeMetadata: metadata,
        // });
        // setShowRoleModal(false);
        
        const userData = {
            id: user.id,
            firstName: user.firstName,
            lastName: user.lastName,
            email: user.emailAddresses[0].emailAddress,
            role,
            orgName,
        };
        const response = await createUser(userData);
        if (response.status === 201) {
            console.log(response.data.organization_id)
            await user.update({
                unsafeMetadata: {
                    role,
                    orgName,
                    organizationId: response.data.organization_id,
                },
            });
            setShowRoleModal(false);
        } else {
            console.log("User creation failed");
        }
    };

    const handleAddService = async (service) => {
        await createService(service);
        const updatedServices = await getServicesByUserId(user.id);
        setServices(updatedServices);
    };

    const handleEditService = async (service) => {
        await updateService(service.id, service);
        const updatedServices = await getServicesByUserId(user.id);
        setServices(updatedServices);
    };

    const handleReportIncident = async () => {
        const updatedServices = await getServicesByUserId(user.id);
    };

    const handleEditTeam = async (teamId, newName) => {
        console.log(teamId, newName);
        await updateTeam(teamId, { name: newName });
        await fetchTeams();
    };

    const handleDeleteTeam = async (teamId) => {
        if (selectedTeam === teamId) setSelectedTeam(null);
        // await import('../api/teamApi').then(api => api.deleteTeam(teamId));
        await deleteTeam(teamId);   
        await fetchTeams();
        await fetchServices();
    };

    const handleDeleteService = async (serviceId) => {
        await deleteService(serviceId);
        const updatedServices = await getServicesByUserId(user.id);
        setServices(updatedServices);
    };

    if (!isLoaded) {
        return <div>Loading...</div>;
    }

    if (!isSignedIn) {
        return <div>User is not signed in</div>;
    }

    if (loadingServices) {
        return <div>Loading services...</div>;
    }

    return (
        <div>
            {showRoleModal && <RoleModal onSubmit={handleRoleSubmit} />}
            {/* <MyComponent /> */}
            <Box sx={{ display: 'flex' }}>
                <TeamsPanel
                    teams={teams}
                    onAddTeam={handleAddTeam}
                    selectedTeamId={selectedTeam}
                    onSelectTeam={setSelectedTeam}
                    user={user}
                    onEditTeam={handleEditTeam}
                    onDeleteTeam={handleDeleteTeam}
                />
                <ServicesGrid 
                    services={services} 
                    teams={teams}
                    user={user}
                    selectedTeam={selectedTeam}
                    onAddService={handleAddService}
                    onEditService={handleEditService}
                    onReportIncident={handleReportIncident}
                    onDeleteService={handleDeleteService}
                />
            </Box>
        </div>
    );
}
