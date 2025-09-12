import { z } from "zod";

export const createAppointmentFormSchema = z.object({
  name: z.string().min(1, "Name is required"),
  email: z.string().email("Enter a valid email"),
  date: z.date({ message: "Date and time are required" }),
  time: z.string(),
});

export type CreateAppointmentFormSchema = z.infer<typeof createAppointmentFormSchema>;
