import NutritionistsList from "../../components/Home/NutritionistsList";
import NutritionistsFilters from "../../components/Home/NutritionistsFilters";

export default function HomePage() {
  return (
    <main>
      <NutritionistsFilters />
      <NutritionistsList />
    </main>
  );
}
