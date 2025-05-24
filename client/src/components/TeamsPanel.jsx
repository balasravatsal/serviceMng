import { useState, useEffect } from 'react';
import {
    Box,
    Paper,
    Typography,
    List,
    ListItem,
    ListItemText,
    IconButton,
    ListItemButton,
    Snackbar,
    Dialog,
    DialogTitle,
    DialogContent,
    DialogContentText,
    DialogActions,
    Button
} from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import MoreVertIcon from '@mui/icons-material/MoreVert';
import EditIcon from '@mui/icons-material/Edit';
import DeleteIcon from '@mui/icons-material/Delete';
import AddTeamModal from './modal/AddTeamModal';
import { requestToJoinTeam, getUserActiveTeams } from '../api/teamMembershipApi';
import { updateTeam, deleteTeam } from '../api/teamApi';
import TextField from '@mui/material/TextField';

export default function TeamsPanel({ teams, onAddTeam, selectedTeamId, onSelectTeam, user, onEditTeam, onDeleteTeam }) {
    const [open, setOpen] = useState(false);
    const [activeTeams, setActiveTeams] = useState([]);
    const [snackbar, setSnackbar] = useState({ open: false, message: '' });
    const [deleteDialog, setDeleteDialog] = useState({ open: false, team: null });
    const [editDialog, setEditDialog] = useState({ open: false, team: null, newName: '' });

    useEffect(() => {
        if (user?.id) {
            console.log('user.id', user.id);
            getUserActiveTeams(user.id).then(setActiveTeams);
        }
    }, [user]);

    const handleJoinTeam = async (teamId) => {
        await requestToJoinTeam(teamId, user.id);
        setSnackbar({ open: true, message: 'Join request sent!' });
    };

    const isAdmin = user?.unsafeMetadata?.role === 'admin';

    const handleEditTeam = (team) => {
        setEditDialog({ open: true, team, newName: team.name });
    };

    const handleDeleteTeam = async (team) => {
        setDeleteDialog({ open: true, team });
    };

    const confirmDeleteTeam = async () => {
        if (deleteDialog.team) {
            await onDeleteTeam(deleteDialog.team.id);
            setSnackbar({ open: true, message: 'Team deleted!' });
        }
        setDeleteDialog({ open: false, team: null });
    };

    const cancelDeleteTeam = () => {
        setDeleteDialog({ open: false, team: null });
    };

    const confirmEditTeam = async () => {
        if (editDialog.team && editDialog.newName && editDialog.newName !== editDialog.team.name) {
            await onEditTeam(editDialog.team.id, editDialog.newName);
            setSnackbar({ open: true, message: 'Team name updated!' });
        }
        setEditDialog({ open: false, team: null, newName: '' });
    };

    const cancelEditTeam = () => {
        setEditDialog({ open: false, team: null, newName: '' });
    };

    return (
        <Paper sx={{ width: { xs: '30%', md: 250 }, p: 2, bgcolor: '#fff', boxShadow: 3, height: '100vh', display: 'flex', flexDirection: 'column' }}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                <Typography variant="h6" color="primary" sx={{ fontWeight: 600 }}>Teams</Typography>
                {isAdmin && (
                    <IconButton color="primary" onClick={() => setOpen(true)}>
                        <AddIcon />
                    </IconButton>
                )}
            </Box>
            <List>
                <ListItem disablePadding>
                    <ListItemButton
                        selected={selectedTeamId === null}
                        onClick={() => onSelectTeam(null)}
                    >
                        <ListItemText primary="All Teams" />
                    </ListItemButton>
                </ListItem>
                {teams.map((team) => {
                    const isActiveMember = activeTeams.includes(team.id);
                    const isMember = user?.unsafeMetadata?.role === 'member';
                    return (
                        <ListItem
                            key={team.id}
                            disablePadding
                            secondaryAction={
                                isAdmin ? (
                                    <Box sx={{ display: 'flex', gap: 1 }}>
                                        <IconButton edge="end" onClick={() => handleEditTeam(team)}>
                                            <EditIcon fontSize="small" />
                                        </IconButton>
                                        <IconButton edge="end" onClick={() => handleDeleteTeam(team)}>
                                            <DeleteIcon fontSize="small" />
                                        </IconButton>
                                    </Box>
                                ) : (
                                    isMember && !isActiveMember && (
                                        <IconButton edge="end" onClick={() => handleJoinTeam(team.id)}>
                                            <span style={{ fontSize: 12 }}>Join Team</span>
                                        </IconButton>
                                    )
                                )
                            }
                        >
                            <ListItemButton
                                selected={selectedTeamId === team.id}
                                onClick={() => onSelectTeam(team.id)}
                                sx={{ borderRadius: 0 }}
                            >
                                <ListItemText primary={team.name} />
                            </ListItemButton>
                        </ListItem>
                    );
                })}
            </List>
            <AddTeamModal
                open={open}
                onClose={() => setOpen(false)}
                onAdd={(teamName) => {
                    onAddTeam(teamName);
                    setOpen(false);
                }}
            />
            <Snackbar
                open={snackbar.open}
                autoHideDuration={3000}
                onClose={() => setSnackbar({ open: false, message: '' })}
                message={snackbar.message}
            />
            <Dialog
                open={deleteDialog.open}
                onClose={cancelDeleteTeam}
            >
                <DialogTitle>Delete Team</DialogTitle>
                <DialogContent>
                    <DialogContentText>
                        Are you sure you want to delete team '{deleteDialog.team?.name}'?
                    </DialogContentText>
                </DialogContent>
                <DialogActions>
                    <Button onClick={cancelDeleteTeam}>Cancel</Button>
                    <Button onClick={confirmDeleteTeam} color="error">Delete</Button>
                </DialogActions>
            </Dialog>
            <Dialog
                open={editDialog.open}
                onClose={cancelEditTeam}
            >
                <DialogTitle>Edit Team Name</DialogTitle>
                <DialogContent>
                    <TextField
                        label="Team Name"
                        value={editDialog.newName}
                        onChange={e => setEditDialog(ed => ({ ...ed, newName: e.target.value }))}
                        fullWidth
                        autoFocus
                        sx={{ mt: 1 }}
                    />
                </DialogContent>
                <DialogActions>
                    <Button onClick={cancelEditTeam}>Cancel</Button>
                    <Button onClick={confirmEditTeam} variant="contained" disabled={!editDialog.newName || editDialog.newName === editDialog.team?.name}>Save</Button>
                </DialogActions>
            </Dialog>
        </Paper>
    );
}
