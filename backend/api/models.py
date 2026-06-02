from django.db import models
from django.contrib.auth.models import AbstractUser


# 1. Modèle Parent (Hérite du système d'authentification de Django)
class Parent(AbstractUser):
    # Les champs username, email, password, first_name, last_name existent déjà
    phone_number = models.CharField(max_length=20, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name} ({self.email})"

# 2. Modèle Enfant
class Child(models.Model):
    parent = models.ForeignKey(Parent, on_delete=models.CASCADE, related_name='children')
    first_name = models.CharField(max_length=100)
    age = models.IntegerField()
    avatar_emoji = models.CharField(max_length=10, default="👦🏻")
    
    # NOUVEAU : Le code secret à 4 chiffres (optionnel pour laisser le choix au parent)
    pin_code = models.CharField(max_length=4, blank=True, null=True) 
    
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.first_name

# 3. Modèle pour les sessions d'activité (Dashboard KPI)
class ActivitySession(models.Model):
    child = models.ForeignKey(Child, on_delete=models.CASCADE, related_name='activities')
    session_date = models.DateField(auto_now_add=True) # Enregistre le jour exact en temps réel
    duration_minutes = models.IntegerField(default=0) # Durée totale de l'activité du jour
    stories_completed = models.IntegerField(default=0) # Nombre d'histoires complétées dans la journée
    stories_names = models.TextField(default="") # Stocke les titres des histoires complétées, séparés par des virgules
    focus_score = models.IntegerField(default=100) # Un score de 0 à 100 représentant le niveau de concentration de l'enfant pendant la session (calculé par l'IA)
 
    def __str__(self):
        return f"Stats de {self.child.first_name} du {self.session_date}"
    

class VoiceInteraction(models.Model):
    child = models.ForeignKey(Child, on_delete=models.CASCADE, related_name='voices')
    # Les fichiers seront physiquement sauvegardés dans backend/media/child_voices/
    audio_file = models.FileField(upload_to='child_voices/')
    timestamp = models.DateTimeField(auto_now_add=True)
    transcript = models.TextField(blank=True, null=True) 

    def __str__(self):
        return f"Audio {self.id} - {self.child.first_name}"

# 1. LA BIBLIOTHÈQUE (Gérée par l'Admin, avec notion de prix)
class Story(models.Model):
    title = models.CharField(max_length=255)
    content_text = models.TextField()
    domain = models.CharField(max_length=50)
    price = models.DecimalField(max_digits=6, decimal_places=2, default=0.00) # Ex: 9.99 MAD
    is_free = models.BooleanField(default=False) # Pour les histoires de démonstration
    created_at = models.DateTimeField(auto_now_add=True)

class StoryPack(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField()
    price = models.DecimalField(max_digits=6, decimal_places=2) # Prix réduit pour le pack
    stories = models.ManyToManyField(Story, related_name='packs')

# 2. E-COMMERCE & ACCÈS (Espace Parent)
class Purchase(models.Model):
    parent = models.ForeignKey('Parent', on_delete=models.CASCADE, related_name='purchases')
    story = models.ForeignKey(Story, on_delete=models.SET_NULL, null=True, blank=True)
    pack = models.ForeignKey(StoryPack, on_delete=models.SET_NULL, null=True, blank=True)
    amount_paid = models.DecimalField(max_digits=6, decimal_places=2)
    transaction_date = models.DateTimeField(auto_now_add=True)

class ChildLibrary(models.Model):
    # Table qui liste exactement à quelles histoires un enfant a accès suite aux achats du parent
    child = models.ForeignKey('Child', on_delete=models.CASCADE, related_name='unlocked_stories')
    story = models.ForeignKey(Story, on_delete=models.CASCADE)
    unlocked_at = models.DateTimeField(auto_now_add=True)

# 3. INTERACTION TEMPS RÉEL (Le "Ping-Pong" entre l'Enfant et l'Agent IA)
class ConversationSession(models.Model):
    child = models.ForeignKey('Child', on_delete=models.CASCADE)
    story = models.ForeignKey(Story, on_delete=models.CASCADE)
    started_at = models.DateTimeField(auto_now_add=True)
    is_active = models.BooleanField(default=True)

class DialogueTurn(models.Model):
    SPEAKER_CHOICES = [
        ('CHILD', 'Enfant'),
        ('IA', 'Agent Nour (IA)'),
    ]
    session = models.ForeignKey(ConversationSession, on_delete=models.CASCADE, related_name='turns')
    speaker = models.CharField(max_length=10, choices=SPEAKER_CHOICES)
    
    # Audio : Micro de l'enfant OU Voix générée (TTS) de l'IA
    audio_file = models.FileField(upload_to='conversation_audio/', blank=True, null=True) 
    
    # Texte : STT (transcription de l'enfant) OU Réponse générée par le LLM
    text_content = models.TextField() 
    
    # Le "cerveau" de l'IA : ce qu'elle a compris (ex: "Demande d'explication", "Poursuite de l'histoire")
    detected_intent = models.CharField(max_length=100, blank=True, null=True) 
    timestamp = models.DateTimeField(auto_now_add=True)