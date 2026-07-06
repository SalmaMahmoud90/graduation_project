from django.shortcuts import render
from .serializers import *
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import *

class CreateReportAPIView(APIView):
    
    def post(self, request):
        
        serializer = CreateReportSerializer(data=request.data, context={"request": request})
        if serializer.is_valid():
          
            report = serializer.save(reporter=request.user)
            return Response(CreateReportSerializer(report).data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
