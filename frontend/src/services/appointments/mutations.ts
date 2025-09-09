import { toastError, toastSuccess } from "@/utils/toasts";
import { useMutation } from "@tanstack/react-query";

export interface CreateAppointmentBodyParams {
  nutritionist_id: number;
  name: string;
  email: string;
  date: string;
}

export async function createAppointment(body: CreateAppointmentBodyParams) {
  const url = new URL("http://localhost:3000/appointments");
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
