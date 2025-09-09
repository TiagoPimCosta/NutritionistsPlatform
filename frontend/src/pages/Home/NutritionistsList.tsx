import ProfessionalCard from "./ProfessionalCard";
import { useGetNutritionists } from "@/services/nutritionists/queries";
import { getRouteApi } from "@tanstack/react-router";
import CustomPagination from "@/components/CustomPagination";

const route = getRouteApi("/");

export default function NutritionistsList() {
  const navigate = route.useNavigate();
  const searchParams = route.useSearch();

  const { data, isLoading } = useGetNutritionists({
    page: searchParams.page || 1,
    per_page: searchParams.per_page || 2,
    filter: searchParams.filter,
  });

  const handleChangePage = (newPage: number) => {
    navigate({ search: (prev) => ({ ...prev, page: newPage }) });
  };

  if (isLoading) {
    return <div className="container mx-auto px-4 py-8 space-y-6">Loading Nutritionists...</div>;
  }

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      {data?.items?.map((professional) => (
        <ProfessionalCard key={professional.id} {...professional} />
      ))}

      {data && (
        <CustomPagination
          currentPage={data.page}
          totalPages={data.total_pages}
          onPageChange={handleChangePage}
        />
      )}
    </div>
  );
}
