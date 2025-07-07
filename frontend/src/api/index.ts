import axios from 'axios'

const api = axios.create({
  baseURL: `${import.meta.env.VITE_API_BASE_URL}/api`,
  timeout: 10000,
})

export interface Room {
  id: number
  name: string
  yearMonth: string
  createdAt: string
  players?: Player[]
  ruleSetting?: RuleSetting
}

export interface Player {
  id: number
  name: string
  nickname?: string
  createdAt: string
}

export interface Game {
  id: number
  roomId: number
  gameDate: string
  startingPlayerId: number
  startingPlayerName: string
  results: GameResult[]
}

export interface GameResult {
  id: number
  gameId: number
  playerId: number
  playerName: string
  rawScore: number
  rank: number
  isTobi: boolean
  finalScore: number
}

export interface RuleSetting {
  id: number
  roomId: number
  uma1st: number
  uma2nd: number
  uma3rd: number
  uma4th: number
  oka: number
  tobiPenalty: number
}

export interface CreateGameRequest {
  roomId: number
  gameDate: string
  startingPlayerId: number
  results: {
    playerId: number
    rawScore: number
    isTobi: boolean
  }[]
}

export const roomApi = {
  getAll: () => api.get<Room[]>('/rooms'),
  getById: (id: number) => api.get<Room>(`/rooms/${id}`),
  create: (room: Omit<Room, 'id' | 'createdAt'>) => api.post<Room>('/rooms', room),
  update: (id: number, room: Partial<Room>) => api.put<Room>(`/rooms/${id}`, room),
  delete: (id: number) => api.delete(`/rooms/${id}`),
  addPlayer: (roomId: number, playerId: number) => api.post(`/rooms/${roomId}/players/${playerId}`),
  removePlayer: (roomId: number, playerId: number) => api.delete(`/rooms/${roomId}/players/${playerId}`),
}

export const playerApi = {
  getAll: () => api.get<Player[]>('/players'),
  getById: (id: number) => api.get<Player>(`/players/${id}`),
  create: (player: Omit<Player, 'id' | 'createdAt'>) => api.post<Player>('/players', player),
  update: (id: number, player: Partial<Player>) => api.put<Player>(`/players/${id}`, player),
  delete: (id: number) => api.delete(`/players/${id}`),
}

const gameApi = {
  getByRoomId: (roomId: number) => api.get<Game[]>(`/games/room/${roomId}`),
  getById: (id: number) => api.get<Game>(`/games/${id}`),
  create: (game: CreateGameRequest) => api.post<Game>('/games', game),
  update: (id: number, game: Partial<Game>) => api.put<Game>(`/games/${id}`, game),
  delete: (id: number) => api.delete(`/games/${id}`),
}

export const ruleApi = {
  getByRoomId: (roomId: number) => api.get<RuleSetting>(`/rules/room/${roomId}`),
  createOrUpdate: (ruleSetting: Omit<RuleSetting, 'id'>) => api.post<RuleSetting>('/rules', ruleSetting),
}

export const statsApi = {
  getDailyStats: (roomId: number) => api.get(`/stats/daily/${roomId}`),
  getYearlyStats: (playerId: number) => api.get(`/stats/yearly/${playerId}`),
}

const extendedGameApi = {
  ...gameApi,
  getByPlayerId: (playerId: number) => api.get<GameResult[]>(`/games/player/${playerId}`)
}

export { extendedGameApi as gameApi }

export default api
