from django.shortcuts import get_object_or_404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import *
from users.models import MainUser
from .serializers import *


class CreateReportView(APIView):

    def post(self, request, user_id):

        reported_user = get_object_or_404(
            MainUser,
            id=user_id
        )

        serializer = CreateReportSerializer(
            data=request.data,
            context={
                "request": request,
                "reported_user": reported_user,
            }
        )

        serializer.is_valid(raise_exception=True)

        report = serializer.save(
            reporter=request.user,
            reported_user=reported_user
        )

        return Response(
            CreateReportSerializer(report).data,
            status=status.HTTP_201_CREATED
        )


class SharedRidesView(APIView):

    def get(self, request, user_id):

        target_user = get_object_or_404(
            MainUser,
            id=user_id
        )

        shared_rides = get_shared_rides(
            request.user,
            target_user
        ).order_by(
            "-departure_date",
            "-departure_time"
        )

        serializer = SharedRideSerializer(
            shared_rides,
            many=True
        )

        return Response(
            serializer.data,
            status=status.HTTP_200_OK
        )


class MyReportsView(APIView):

    def get(self, request):

        reports = Report.objects.filter(
            reporter=request.user
        ).order_by("-created_at")

        serializer = MyReportsSerializer(
            reports,
            many=True
        )

        return Response(
            {"reports": serializer.data},
            status=status.HTTP_200_OK
        )
    
class ViewReportDetailsView(APIView):
    def get(self, request, report_id):

            try:
                report = Report.objects.get(
                    id=report_id,
                    reporter=request.user
                )
            except Report.DoesNotExist:
                return Response(
                    {"error": "Report not found."},
                    status=status.HTTP_404_NOT_FOUND
                )
            serializer = ViewReportDetailsSerializer(report)
    
            return Response(
                serializer.data,
                status=status.HTTP_200_OK
            )