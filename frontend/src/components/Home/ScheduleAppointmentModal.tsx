import { Button } from "@/components/ui/button";
import { Calendar } from "@/components/ui/calendar";
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Popover, PopoverContent, PopoverTrigger } from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import dayjs from "dayjs";
import { useState } from "react";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { ChevronDownIcon } from "lucide-react";
import {
  createAppointmentFormSchema,
  type CreateAppointmentFormSchema,
} from "@/schemas/appointments";
import { parseAppointmentDate } from "@/utils/date";
import { useCreateAppointment } from "@/services/appointments/mutations";
import FormError from "../FormError";

interface ScheduleAppointmentModalProps {
  children: React.ReactNode;
  nutritionistId: number;
}

export function ScheduleAppointmentModal(props: ScheduleAppointmentModalProps) {
  const { children } = props;

  const [calendarOpen, setCalendarOpen] = useState(false);
  const [dialogOpen, setDialogOpen] = useState(false);

  const createAppointment = useCreateAppointment();

  const { register, handleSubmit, control, formState, reset } =
    useForm<CreateAppointmentFormSchema>({
      resolver: zodResolver(createAppointmentFormSchema),
      defaultValues: {
        name: undefined,
        email: undefined,
        date: undefined,
        time: undefined,
      },
    });
  const { errors } = formState;

  const handleSubmitScheduleAppointment = handleSubmit(async (data) => {
    const submittedData = {
      nutritionist_id: props.nutritionistId,
      name: data.name,
      email: data.email,
      date: parseAppointmentDate(data.date, data.time),
    };

    await createAppointment.mutateAsync(submittedData);
    setDialogOpen(false);
    reset();
  });

  return (
    <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
      <DialogTrigger asChild>{children}</DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader className="pb-4">
          <DialogTitle>Schedule appointment</DialogTitle>
        </DialogHeader>
        <form className="flex flex-col gap-4" onSubmit={handleSubmitScheduleAppointment}>
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="name" className="sr-only">
              Name
            </Label>
            <Input id="name" type="text" placeholder="Name" {...register("name")} />
            <FormError errorMessage={errors.name?.message} />
          </div>
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="email" className="sr-only">
              Email
            </Label>
            <Input id="email" type="email" placeholder="Email" {...register("email")} />
            <FormError errorMessage={errors.email?.message} />
          </div>
          <div className="flex flex-col gap-1.5">
            <div className="flex gap-4">
              <div className="flex flex-col flex-1 gap-2">
                <Label htmlFor="date-picker" className="px-1 sr-only">
                  Date
                </Label>
                <Controller
                  control={control}
                  name="date"
                  render={({ field: { value, onChange } }) => (
                    <Popover open={calendarOpen} onOpenChange={setCalendarOpen}>
                      <PopoverTrigger asChild>
                        <Button
                          id="date-picker"
                          type="button"
                          className={cn(
                            "justify-between font-normal bg-input text-muted-foreground hover:bg-input",
                            value && "text-foreground"
                          )}
                        >
                          {value ? dayjs(value).format("DD MMM YYYY") : "Select date"}
                          <ChevronDownIcon />
                        </Button>
                      </PopoverTrigger>
                      <PopoverContent className="w-auto overflow-hidden p-0" align="start">
                        <Calendar
                          mode="single"
                          selected={value}
                          captionLayout="dropdown"
                          onSelect={(d) => {
                            onChange(d);
                            setCalendarOpen(false);
                          }}
                        />
                      </PopoverContent>
                    </Popover>
                  )}
                />
              </div>
              <div className="flex flex-col flex-1 gap-2">
                <Label htmlFor="time-picker" className="px-1 sr-only">
                  Time
                </Label>
                <Input
                  type="time"
                  id="time-picker"
                  className="appearance-none [&::-webkit-calendar-picker-indicator]:hidden [&::-webkit-calendar-picker-indicator]:appearance-none"
                  {...register("time")}
                />
              </div>
            </div>
            <FormError errorMessage={errors.date?.message} />
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button
                variant="destructive"
                type="button"
                onClick={() => {
                  reset();
                }}
              >
                Close
              </Button>
            </DialogClose>
            <Button type="submit">Save changes</Button>
          </DialogFooter>
        </form>
      </DialogContent>
    </Dialog>
  );
}
