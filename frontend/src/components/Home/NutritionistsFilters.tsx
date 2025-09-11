import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { getRouteApi } from "@tanstack/react-router";
import { LocateFixed } from "lucide-react";
import { useState } from "react";

const route = getRouteApi("/");

export default function NutritionistsFilters() {
  const navigate = route.useNavigate();
  const searchParams = route.useSearch();

  const [filter, setFilter] = useState(searchParams.filter ?? "");

  const handleChangeInputValue = (e: React.ChangeEvent<HTMLInputElement>) => {
    setFilter(e.target.value);
  };

  const handleInputPressEnter = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter") handleChangeFilter();
  };

  const handleChangeFilter = () => {
    navigate({ search: (prev) => ({ ...prev, page: 1, filter: filter || undefined }) });
  };

  return (
    <div className="bg-nutritionistsFilter text-nutritionistsFilter-foreground">
      <div className="container mx-auto px-4 py-8">
        <div className="flex flex-col md:flex-row gap-4 mx-auto">
          <div className="flex-1">
            <Input
              placeholder="Name, service, online appointment..."
              className="h-14 text-lg border-0 shadow-lg pl-6"
              value={filter}
              onChange={handleChangeInputValue}
              onKeyDown={handleInputPressEnter}
            />
          </div>
          <div className="flex-1 relative">
            <Input placeholder="Location" className="h-14 text-lg border-0 shadow-lg pl-6" />
            <LocateFixed
              color="#5ab488"
              className="absolute right-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-muted-foreground"
            />
          </div>
          <Button
            size="lg"
            className="h-14 px-12 bg-accent hover:bg-accent/90 text-accent-foreground font-semibold"
            onClick={handleChangeFilter}
          >
            Search
          </Button>
        </div>
      </div>
    </div>
  );
}
