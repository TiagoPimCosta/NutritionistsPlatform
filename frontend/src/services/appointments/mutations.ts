import queryClient from "@/config/queryClient";
import { ENV } from "@/utils/consts";
import { toastError, toastSuccess } from "@/utils/toasts";
import { useMutation } from "@tanstack/react-query";

async function parseResponse(response: Response): Promise<ApiResponseMessage> {
  const data = await response.json().catch(() => null);

  if (!response.ok) {
    const message = Array.isArray(data)
      ? data.map((error: { message: string }) => error.message).join(", ")
      : (data?.message ?? "Something went wrong. Please try again.");

    throw new Error(message);
  }

  return data as ApiResponseMessage;
}

export interface CreateAppointmentBodyParams {
  nutritionist_service_id: string;
  name: string;
  email: string;
  starts_at: string;
}

export async function createAppointment(body: CreateAppointmentBodyParams) {
  const url = new URL(ENV.VITE_API_URL + "appointments");
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
      return parseResponse(response);
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
  appointmentId: string;
  nutritionistId: string;
}

export async function acceptAppointment(params: AcceptAppointmentParams) {
  const { appointmentId } = params;
  const url = new URL(
    ENV.VITE_API_URL + `appointments/${appointmentId}/accept`,
  );

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
      return parseResponse(response);
    },
    onError: (error) => {
      toastError(error.message);
    },
    onSuccess: (data, vars) => {
      toastSuccess(data.message);
      queryClient.invalidateQueries({
        queryKey: ["nutritionist_pending_appointments", vars.nutritionistId],
      });
    },
  });
}

interface RejectAppointmentParams {
  appointmentId: string;
  nutritionistId: string;
}

export async function rejectAppointment(params: RejectAppointmentParams) {
  const { appointmentId } = params;
  const url = new URL(
    ENV.VITE_API_URL + `appointments/${appointmentId}/reject`,
  );

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
      return parseResponse(response);
    },
    onError: (error) => {
      toastError(error.message);
    },
    onSuccess: (data, vars) => {
      toastSuccess(data.message);
      queryClient.invalidateQueries({
        queryKey: ["nutritionist_pending_appointments", vars.nutritionistId],
      });
    },
  });
}
