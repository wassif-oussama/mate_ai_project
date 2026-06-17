from django.urls import path, include
from rest_framework.routers import DefaultRouter
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from .views import ParentViewSet, ChildViewSet, ActivitySessionViewSet, RegisterView, ConversationTurnView, StoryViewSet 



router = DefaultRouter()
router.register(r'parents', ParentViewSet)
router.register(r'children', ChildViewSet, basename='child')
router.register(r'activities', ActivitySessionViewSet)
router.register(r'stories', StoryViewSet)



urlpatterns = [
    # Routes Espace Parent / Auth
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('auth/login/', TokenObtainPairView.as_view(), name='login'),
    
    # Route Espace Enfant (Envoi Audio Temps Réel)
    path('conversation/turn/', ConversationTurnView.as_view(), name='conversation_turn'), 
    
    path('', include(router.urls)),
]
