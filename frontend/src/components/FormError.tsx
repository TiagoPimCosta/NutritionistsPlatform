interface FormErrorProps {
  errorMessage: string | undefined;
}

function FormError(props: FormErrorProps) {
  const { errorMessage } = props;
  return (
    <>{errorMessage && <span className="px-1 text-sm text-destructive">{errorMessage}</span>}</>
  );
}

export default FormError;
