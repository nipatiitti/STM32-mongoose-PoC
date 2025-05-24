import { BASE_URL } from "."

export type Speeds = {
  led1: number
  led2: number
  led3: number
}

export const getSpeeds = async () => {
  const response = await fetch(`${BASE_URL}/speed`)

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  const data = (await response.json()) as Speeds
  return data
}

export const setSpeeds = async (speeds: Speeds) => {
  const response = await fetch(`${BASE_URL}/speed`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(speeds),
  })

  if (!response.ok) {
    throw new Error(`HTTP error! status: ${response.status}`)
  }
  const data = (await response.json()) as Speeds
  return data
}
