export function formatTime(seconds: number): string {
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const remainingSeconds = Math.floor(seconds % 60);

    let time = '';
    if (hours) time += `${hours}h`;
    if (hours || minutes) time += ` ${minutes}m`;
    time += ` ${remainingSeconds}s`;

    return time;
}