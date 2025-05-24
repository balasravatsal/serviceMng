import { Modal, Box, Typography } from '@mui/material';
import Timeline from '@mui/lab/Timeline';
import TimelineItem from '@mui/lab/TimelineItem';
import TimelineSeparator from '@mui/lab/TimelineSeparator';
import TimelineConnector from '@mui/lab/TimelineConnector';
import TimelineContent from '@mui/lab/TimelineContent';
import TimelineDot from '@mui/lab/TimelineDot';

export default function TimelineModal({ open, onClose, service, partitionedTimelines, getStatusColor, loading }) {
    return (
        <Modal open={open} onClose={onClose}>
            <Box sx={{ position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -50%)', bgcolor: '#fff', boxShadow: 24, p: 4, minWidth: 350, maxWidth: '90vw', maxHeight: '90vh', overflowY: 'auto', textAlign: 'left' }}>
            {/* <Box> */}
                <Typography variant="h5" color="primary" sx={{ fontWeight: 600, mb: 2 }}>{service?.name} Timeline</Typography>
                {loading ? (
                    <Typography>Loading timeline...</Typography>
                ) : Object.keys(partitionedTimelines).length === 0 ? (
                    <Typography>No incidents or updates for this service.</Typography>
                ) : (
                    Object.values(partitionedTimelines).map((updates) => {
                        const last = updates[updates.length - 1];
                        return (
                            <Box key={updates[0].incident_id} sx={{ mb: 4 }}>
                                <Typography variant="subtitle1" sx={{ fontWeight: 600, mb: 1, pl: 0 }}>{updates[0].incident_title}</Typography>
                                <Box sx={{ display: 'flex', alignItems: 'flex-start' }}>
                                    <Timeline sx={{ m: 0, p: 0, minWidth: 0 }}>
                                        {updates.map((update, i) => (
                                            <TimelineItem
                                                sx={{
                                                minHeight: 0,
                                                '&::before': {
                                                    display: 'none'
                                                }
                                                }}
                                                key={update.id}
                                            >
                                                <TimelineSeparator>
                                                <TimelineDot color={getStatusColor(update.status)} />
                                                {(i !== updates.length - 1 || last.status !== 'Resolved') && <TimelineConnector />}
                                                </TimelineSeparator>
                                                <TimelineContent sx={{ pl: 1 }}>
                                                <Typography variant="subtitle2" sx={{ fontWeight: 600 }}>
                                                    {update.status}
                                                </Typography>
                                                {update.message && (
                                                    <Typography variant="body2">{update.message}</Typography>
                                                )}
                                                <Typography variant="caption" color="text.secondary">
                                                    {new Date(update.timestamp).toLocaleString()}
                                                </Typography>
                                                </TimelineContent>
                                            </TimelineItem>

                                        ))}
                                    </Timeline>
                                </Box>
                            </Box>
                        );
                    })
                )}
            </Box>
        </Modal>
    );
} 