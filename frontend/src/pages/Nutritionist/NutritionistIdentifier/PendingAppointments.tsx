import {
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselNext,
  CarouselPrevious,
} from "@/components/ui/carousel";
import PendingAppointmentCard from "./PendingAppointmentCard";

const pendingAppointments = [
  {
    id: 1,
    date: "2025-09-08T00:00:00.000Z",
    guest: {
      name: "Tiago Costa",
    },
  },
  {
    id: 2,
    date: "2025-09-08T18:00:00.000Z",
    guest: {
      name: "Tiago Pimenta",
    },
  },
  {
    id: 3,
    date: "2025-09-08T00:00:00.000Z",
    guest: {
      name: "Fátima Braga",
    },
  },
  {
    id: 4,
    date: "2025-09-08T00:00:00.000Z",
    guest: {
      name: "Aires Braga",
    },
  },
];

export default function PendingAppointments() {
  return (
    <div className="container mx-auto px-4 py-8 space-y-6">
      <div className="flex flex-col">
        <h1 className="text-3xl text-muted-foreground">Pending Requests</h1>
        <span className="text-lg text-muted-foreground">Accept or reject pending requests</span>
      </div>
      <Carousel className="w-full">
        <CarouselContent className="w-full">
          {pendingAppointments.map((appointment) => (
            <CarouselItem key={appointment.id} className="basis-1/3">
              <PendingAppointmentCard {...appointment} />
            </CarouselItem>
          ))}
        </CarouselContent>
        <CarouselPrevious />
        <CarouselNext />
      </Carousel>
    </div>
  );
}
