package hipstershop;

import io.grpc.*;
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Timer;

public class MetricsInterceptor implements ServerInterceptor {
    private final MeterRegistry meterRegistry;

    public MetricsInterceptor(MeterRegistry meterRegistry) {
        this.meterRegistry = meterRegistry;
    }

    @Override
    public <ReqT, RespT> ServerCall.Listener<ReqT> interceptCall(
        ServerCall<ReqT, RespT> call,
        Metadata headers,
        ServerCallHandler<ReqT, RespT> next) {

        String methodName = call.getMethodDescriptor().getFullMethodName();
        Timer.Sample sample = Timer.start(meterRegistry);

        return new ForwardingServerCallListener.SimpleForwardingServerCallListener<ReqT>(
            next.startCall(new ForwardingServerCall.SimpleForwardingServerCall<ReqT, RespT>(call) {
                @Override
                public void close(Status status, Metadata trailers) {
                    sample.stop(Timer.builder("grpc.server.duration")
                        .tag("method", methodName)
                        .tag("status", status.getCode().name())
                        .register(meterRegistry));

                    meterRegistry.counter("grpc.server.requests.total",
                            "method", methodName,
                            "status", status.getCode().name())
                        .increment();

                    super.close(status, trailers);
                }
            }, headers)) {
        };
    }
}
