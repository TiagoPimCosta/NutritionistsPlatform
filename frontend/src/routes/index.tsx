import { createFileRoute } from "@tanstack/react-router";
import HomePage from "@/pages/Home";
import { paginationParamsSchema } from "@/schemas/paginationSchema";
import { getNutritionistsServicesSchema } from "@/schemas/nutritionistsServices/getNutritionistsServicesSchema";

export const Route = createFileRoute("/")({
  validateSearch: getNutritionistsServicesSchema.and(paginationParamsSchema),
  component: HomePage,
});
