import { z } from "zod";

export const getNutritionistsServicesSchema = z.object({
  filter: z.string().optional(),
});

export type GetNutritionistsServicesSchema = z.infer<typeof getNutritionistsServicesSchema>;
