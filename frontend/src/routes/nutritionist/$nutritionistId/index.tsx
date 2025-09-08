import NutritionistPage from "@/pages/Nutritionist/NutritionistIdentifier";
import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/nutritionist/$nutritionistId/")({
  component: NutritionistPage,
});
