import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { MapPin, Star, Banknote, BriefcaseBusiness, ChevronDown } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Link } from "@tanstack/react-router";
import { ScheduleAppointmentModal } from "./ScheduleAppointmentModal";

interface ProfessionalCardProps {
  id: string;
  name: string;
  title: string;
  credentials: string;
  location: string;
  city: string;
  price: number;
}

const ProfessionalCard = (props: ProfessionalCardProps) => {
  const { id, name, title, credentials, location, city, price } = props;

  const nameInitials = name
    .split(" ")
    .map((n) => n[0])
    .join("");

  return (
    <Card className="p-6 shadow-md hover:shadow-lg transition-shadow">
      <CardContent className="p-0">
        <div className="flex gap-8">
          {/* Avatar */}
          <Avatar className="h-24 w-24">
            <AvatarImage src="/public/avatar-icon.png" alt={name} />
            <AvatarFallback className="bg-primary/10 text-primary font-semibold">
              {nameInitials}
            </AvatarFallback>
          </Avatar>

          {/* Main content */}
          <div className="flex-1">
            <div className="flex flex-col items-start justify-between gap-6">
              <div>
                <Badge variant="followUp" className="text-xs font-extrabold">
                  <Star className="h-5 w-5" />
                  FOLLOW-UP
                </Badge>

                <h3 className="text-2xl font-semibold text-primary mb-1">{name}</h3>
                <p className="text-muted-foreground">
                  {title} • {credentials}
                </p>
              </div>

              {/* Details */}
              <div className="flex flex-row w-full justify-between">
                <div className="flex flex-col gap-3">
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <MapPin className="h-6 w-6 text-primary" />
                    <span className="text-primary font-medium">Online Follow-up</span>
                  </div>

                  <span className="pl-8 text-muted-foreground">{location}</span>
                  <span className="pl-8 text-muted-foreground">{city}</span>
                </div>

                <div className="flex flex-col gap-2">
                  <div className="flex gap-2 items-center">
                    <BriefcaseBusiness className="h-5 w-5 text-primary" />
                    <span className="flex flex-row text-sm text-muted-foreground">
                      First appointment <ChevronDown className="h-5 w-5 text-muted-foreground" />
                    </span>
                  </div>
                  <div className="flex gap-2 items-center">
                    <Banknote className="h-5 w-5 text-primary" />
                    <span className="text-muted-foreground">€ {price}.00</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Action buttons */}
          <div className="flex flex-col gap-2 ml-4">
            <ScheduleAppointmentModal nutritionistId={id}>
              <Button size="lg" variant="schedule" className="w-64">
                Schedule appointment
              </Button>
            </ScheduleAppointmentModal>
            <Button size="lg" variant="website" className="w-64" asChild>
              <Link to="/nutritionist/$nutritionistId" params={{ nutritionistId: String(id) }}>
                Website
              </Link>
            </Button>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};

export default ProfessionalCard;
