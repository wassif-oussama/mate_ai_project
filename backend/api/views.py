from datetime import date
from rest_framework import viewsets
from .models import Parent, Child, ActivitySession
from rest_framework.permissions import IsAuthenticated
from .serializers import ParentSerializer, ChildSerializer, ActivitySessionSerializer
from rest_framework import generics
from rest_framework.permissions import AllowAny
from .serializers import RegisterSerializer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework import status
from .models import ConversationSession, DialogueTurn
from .serializers import DialogueTurnSerializer
from .models import Story
from .serializers import StorySerializer

# Vue spécifique pour l'inscription (Ouverte à tous, pas besoin d'être connecté)
class RegisterView(generics.CreateAPIView):
    queryset = Parent.objects.all()
    permission_classes = (AllowAny,)
    serializer_class = RegisterSerializer

class ParentViewSet(viewsets.ModelViewSet):
    queryset = Parent.objects.all()
    permission_classes = [AllowAny]
    serializer_class = ParentSerializer

class ChildViewSet(viewsets.ModelViewSet):
    serializer_class = ChildSerializer
    permission_classes = [IsAuthenticated] # Exige un Token valide

    def get_queryset(self):
        # Retourne UNIQUEMENT les enfants du parent actuellement connecté !
        return Child.objects.filter(parent=self.request.user)

class ActivitySessionViewSet(viewsets.ModelViewSet):
    queryset = ActivitySession.objects.all()
    permission_classes = [AllowAny]
    serializer_class = ActivitySessionSerializer


class ConversationTurnView(APIView):
    parser_classes = (MultiPartParser, FormParser)
    
    def post(self, request, *args, **kwargs):
        audio_file = request.FILES.get('audio_file')
        session_id = request.data.get('session_id')
        
        if not audio_file or not session_id:
            return Response({"error": "Données manquantes"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            session = ConversationSession.objects.get(id=session_id)
        except ConversationSession.DoesNotExist:
            return Response({"error": "Session introuvable"}, status=status.HTTP_404_NOT_FOUND)

        # 1. Sauvegarde du tour de parole de l'enfant
        child_turn = DialogueTurn.objects.create(
            session=session,
            speaker='CHILD',
            audio_file=audio_file,
            text_content="[En attente de transcription...]"
        )

        # 2. AUTOMATISATION DU DASHBOARD EN TEMPS RÉEL
        today = date.today()
        story_title = session.story.title # Récupère le vrai nom de l'histoire

        # Récupère ou crée la session de statistiques pour ce jour précis
        activity, created = ActivitySession.objects.get_or_create(
            child=session.child,
            session_date=today,
            defaults={
                'duration_minutes': 0,
                'stories_completed': 0,
                'stories_names': "",
                'focus_score': 100
            }
        )

        # Ajoute du temps d'interaction (ex: +2 minutes par échange audio)
        activity.duration_minutes += 2

        # Gestion de la liste des noms d'histoires lues aujourd'hui
        current_stories = [s.strip() for s in activity.stories_names.split(',') if s.strip()]
        if story_title not in current_stories:
            current_stories.append(story_title)
            activity.stories_completed = len(current_stories) # Compte le nombre d'histoires
            activity.stories_names = ", ".join(current_stories) # Concatène les noms

        activity.save()

        # 3. Réponse simulée de l'agent
        ia_turn = DialogueTurn.objects.create(
            session=session,
            speaker='IA',
            text_content="أحسنت يا بطل! ماذا حدث بعد ذلك؟",
        )

        serializer = DialogueTurnSerializer(ia_turn)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    

class StoryViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API endpoint pour lister toutes les histoires disponibles.
    ReadOnlyModelViewSet garantit que Flutter ne peut faire que des requêtes GET.
    """
    queryset = Story.objects.all().order_by('-created_at')
    serializer_class = StorySerializer
    # Si tu veux que la bibliothèque soit visible même sans être connecté, 
    # tu peux ajouter : permission_classes = [AllowAny]