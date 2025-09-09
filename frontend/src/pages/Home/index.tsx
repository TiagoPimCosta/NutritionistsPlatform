import NutritionistsList from "./NutritionistsList";
import NutritionistsFilters from "./NutritionistsFilters";

export default function HomePage() {
  return (
    <main>
      <NutritionistsFilters />
      <NutritionistsList />
    </main>
  );
}
