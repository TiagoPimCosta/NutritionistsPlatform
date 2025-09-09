import { createFileRoute } from "@tanstack/react-router";
import HomePage from "@/pages/Home";
import { getNutritionistsSchema } from "@/schemas/nutritionists/getNutritionistsSchema";
import { paginationParamsSchema } from "@/schemas/paginationSchema";

export const Route = createFileRoute("/")({
  validateSearch: getNutritionistsSchema.and(paginationParamsSchema),
  component: HomePage,
});
