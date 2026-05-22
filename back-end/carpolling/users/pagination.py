from rest_framework.pagination import LimitOffsetPagination
from rest_framework.response import Response
from math import ceil
class CustomerLimitOffsetPagination(LimitOffsetPagination):
    default_limit = 10
    max_limit = 50
    def get_paginated_response(self, data):
        total_pages= ceil(self.count/self.limit)
        return Response({
            'count': self.count,
            'total_pages': total_pages,
            'next': self.get_next_link(),
            'previous': self.get_previous_link(),
            'results': data
        })