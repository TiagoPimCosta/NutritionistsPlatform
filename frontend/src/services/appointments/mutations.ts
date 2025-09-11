import queryClient from "@/config/queryClient";
import { ENV } from "@/utils/consts";
import { toastError, toastSuccess } from "@/utils/toasts";
import { useMutation } from "@tanstack/react-query";

export interface CreateAppointmentBodyParams {
  nutritionist_id: number;
  name: string;
  email: string;
  date: string;
}

export async function createAppointment(body: CreateAppointmentBodyParams) {
  const url = new URL(ENV.VITE_API_URL + "/appointments");
  return fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });
}

export function useCreateAppointment() {
  return useMutation<ApiResponseMessage, Error, CreateAppointmentBodyParams>({
    mutationFn: async (vars) => {
      const response = await createAppointment(vars);
      const data = await response.json();
      return data as ApiResponseMessage;
    },
    onError: (error) => {
      toastError(error.message);
    },
    onSuccess: (data) => {
      toastSuccess(data.message);
    },
  });
}

interface AcceptAppointmentParams {
  appointmentId: number;
  nutritionistId: number;
}

export async function acceptAppointment(params: AcceptAppointmentParams) {
  const { appointmentId } = params;
  const url = new URL(ENV.VITE_API_URL + `/appointments/${appointmentId}/accept`);

  return fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
  });
}

export function useAcceptAppointment() {
  return useMutation<ApiResponseMessage, Error, AcceptAppointmentParams>({
    mutationFn: async (vars) => {
      const response = await acceptAppointment(vars);
      const data = await response.json();
      return data as ApiResponseMessage;
    },
    onError: (error) => {
      toastError(error.message);
    },
    onSuccess: (data, vars) => {
      toastSuccess(data.message);
      queryClient.invalidateQueries({
        queryKey: ["nutritionist_pending_appointments", String(vars.nutritionistId)],
      });
    },
  });
}

interface RejectAppointmentParams {
  appointmentId: number;
  nutritionistId: number;
}

export async function rejectAppointment(params: RejectAppointmentParams) {
  const { appointmentId } = params;
  const url = new URL(ENV.VITE_API_URL + `/appointments/${appointmentId}/reject`);

  return fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
  });
}

export function useRejectAppointment() {
  return useMutation<ApiResponseMessage, Error, RejectAppointmentParams>({
    mutationFn: async (vars) => {
      const response = await rejectAppointment(vars);
      const data = await response.json();
      return data as ApiResponseMessage;
    },
    onError: (error) => {
      toastError(error.message);
    },
    onSuccess: (data, vars) => {
      toastSuccess(data.message);
      queryClient.invalidateQueries({
        queryKey: ["nutritionist_pending_appointments", String(vars.nutritionistId)],
      });
    },
  });
}
