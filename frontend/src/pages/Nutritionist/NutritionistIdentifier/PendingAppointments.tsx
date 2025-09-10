import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import PendingAppointmentCard from "./PendingAppointmentCard";
import { useGetNutritionistPendingAppointments } from "@/services/nutritionists/queries";
import { getRouteApi } from "@tanstack/react-router";

const route = getRouteApi("/nutritionist/$nutritionistId/");

export default function PendingAppointments() {
  const params = route.useParams();

  const { data, isLoading } = useGetNutritionistPendingAppointments({
    id: params.nutritionistId,
  });

  if (isLoading) {
    return (
      <div className="container mx-auto px-4 py-8 space-y-6">
        Loading Nutritionist pending requets...
      </div>
    );
  }

  const appointmentCards = () => {
    if (!data?.length) {
      return (
        <div className="pt-5 h-24 text-center text-muted-foreground text-lg">
          There are currently no pending requests. Please check back later.
        </div>
      );
    } else {
      return (
        <Carousel className="w-full">
          <CarouselContent className="w-full">
            {data.map((appointment) => (
              <CarouselItem key={appointment.id} className="basis-1/3">
                <PendingAppointmentCard appointment={appointment} />
              </CarouselItem>
            ))}
          </CarouselContent>
          <CarouselPrevious />
          <CarouselNext />
        </Carousel>
      );
    }
  };

  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      <div className="flex flex-col">
        <h1 className="text-3xl text-muted-foreground">Pending Requests</h1>
        <span className="text-lg text-muted-foreground">Accept or reject pending requests</span>
      </div>
      {appointmentCards()}
    </div>
  );
}
