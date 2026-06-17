from rest_framework import serializers
from .models import Parent, Child, ActivitySession
from django.contrib.auth.hashers import make_password
from .models import DialogueTurn
from .models import Story

class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = Parent
        fields = ('username', 'email', 'password', 'first_name', 'last_name')
        extra_kwargs = {'password': {'write_only': True}} # Le mot de passe ne sera jamais renvoyé en lecture

    def create(self, validated_data):
        # On utilise create_user qui s'occupe de crypter le mot de passe automatiquement
        parent = Parent.objects.create_user(
            username=validated_data['username'],
            email=validated_data.get('email', ''),
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', '')
        )
        return parent

class ChildSerializer(serializers.ModelSerializer):
    class Meta:
        model = Child
        fields = ['id', 'first_name', 'age', 'avatar_emoji', 'pin_code']

class ParentSerializer(serializers.ModelSerializer):
    # Permet d'inclure la liste des enfants directement quand on récupère le profil du parent
    children = ChildSerializer(many=True, read_only=True)

    class Meta:
        model = Parent
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'phone_number', 'children']

class ActivitySessionSerializer(serializers.ModelSerializer):
    class Meta:
        model = ActivitySession
        fields = ['id', 'child', 'session_date', 'duration_minutes', 'stories_completed', 'stories_names', 'focus_score']



class DialogueTurnSerializer(serializers.ModelSerializer):
    class Meta:
        model = DialogueTurn
        fields = ['id', 'session', 'speaker', 'audio_file', 'text_content', 'detected_intent', 'timestamp']

class StorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Story
        fields = ['id', 'title', 'content_text', 'domain', 'price', 'is_free', 'created_at']