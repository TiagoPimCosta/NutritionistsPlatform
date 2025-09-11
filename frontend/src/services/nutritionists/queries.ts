import { ENV } from "@/utils/consts";
import { keepPreviousData, useQuery } from "@tanstack/react-query";

export interface NutritionistPendingAppointmentsObj {
  id: number;
  date: string;
  status_id: number;
  nutritionist_id: number;
  created_at: string;
  updated_at: string;
  guest_id: number;
  guest: {
    id: number;
    name: string;
    email: string;
  };
}

export type GetNutritionistPendingAppointmentsParams = { id: string };
export type GetNutritionistPendingAppointmentsResponse = NutritionistPendingAppointmentsObj[];

export function getNutritionistPendingAppointments(
  params: GetNutritionistPendingAppointmentsParams
) {
  const url = new URL(ENV.VITE_API_URL + params.id + "/pending_requests");

  return fetch(url);
}

export function useGetNutritionistPendingAppointments(
  params: GetNutritionistPendingAppointmentsParams
) {
  return useQuery({
    queryKey: ["nutritionist_pending_appointments", params.id],
    placeholderData: keepPreviousData,
    queryFn: async () => {
      const response = await getNutritionistPendingAppointments(params);
      if (!response.ok) {
        const error = new Error(`Request failed with status ${response.status}`);
        throw error;
      }
      return (await response.json()) as GetNutritionistPendingAppointmentsResponse;
    },
  });
}
