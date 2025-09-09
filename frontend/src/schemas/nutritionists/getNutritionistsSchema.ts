import { z } from "zod";

export const getNutritionistsSchema = z.object({
  filter: z.string().optional(),
});

export type GetNutritionistsSchema = z.infer<typeof getNutritionistsSchema>;
