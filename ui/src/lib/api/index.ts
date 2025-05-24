const ip = import.meta.env.VITE_MG_IP || false

export const BASE_URL = ip ? `http://${ip}:80/api` : "/api"
